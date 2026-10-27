"""Teaching implementation of deleted-line SZZ using PyDriller and git blame.

Usage: python szz_tracer.py <fix_commit_hash> [repository_path]
"""
import argparse
import re
import subprocess
from pathlib import Path
from pydriller import Repository


def git(repo, *args):
    result = subprocess.run(["git", *args], cwd=repo, text=True,
                            capture_output=True, check=True)
    return result.stdout.strip()


def main():
    parser = argparse.ArgumentParser(description="Trace candidate bug-inducing commits")
    parser.add_argument("fix_hash", help="Bug-fixing commit hash")
    parser.add_argument("repo_path", nargs="?", default=".", help="Git repository path")
    args = parser.parse_args()
    repo = str(Path(args.repo_path).resolve())
    try:
        git(repo, "rev-parse", "--show-toplevel")
        fix_hash = git(repo, "rev-parse", f"{args.fix_hash}^{{commit}}")
        parent = git(repo, "rev-parse", f"{fix_hash}^1")
        commits = list(Repository(repo, single=fix_hash).traverse_commits())
    except (subprocess.CalledProcessError, ValueError) as exc:
        parser.exit(1, f"Cannot load fix or its first parent: {exc}\n")

    candidates = set()
    if not commits:
        parser.exit(1, "Fix commit not found by PyDriller.\n")
    print(f"BFC: {fix_hash}\nParent: {parent}\n")
    for modified in commits[0].modified_files:
        old_path = modified.old_path
        deleted = modified.diff_parsed.get("deleted", [])
        print(f"File: {old_path or modified.new_path} | deleted lines: {len(deleted)}")
        if not old_path or not deleted:
            print("  No traceable deleted lines (added-only or no old path).")
            continue
        for line_number, line_text in deleted:
            try:
                output = git(repo, "blame", "--porcelain", "-L",
                             f"{line_number},{line_number}", parent, "--", old_path)
                first_line = output.splitlines()[0]
                match = re.match(r"^([0-9a-f]{40})\s", first_line)
                if not match or match.group(1) == "0" * 40:
                    print(f"  Line {line_number}: no attributable commit")
                    continue
                bic = match.group(1)
                candidates.add(bic)
                print(f"  Line {line_number}: {bic[:12]} | {line_text.strip()}")
            except (subprocess.CalledProcessError, IndexError) as exc:
                print(f"  Line {line_number}: blame failed ({exc})")
    print("\nCandidate BICs (not proof of causation):")
    if candidates:
        for bic in sorted(candidates):
            print(f"  {bic}")
    else:
        print("  None found. Inspect added-only fixes and context manually.")


if __name__ == "__main__":
    main()
