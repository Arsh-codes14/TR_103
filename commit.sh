#!/usr/bin/env bash
set -euo pipefail

# --- CONFIG ---
# Adjust the branch name if you use something else
BRANCH="main"

# Time of day to use for commits (IST). Keep same time for simplicity.
TIME_OF_DAY="12:00:00+05:30"

# Optional: Uncomment and set your remote before pushing, or run manually later:
# REMOTE_URL="git@github.com:yourusername/yourrepo.git"

# --- SAFETY CHECKS ---
# Ensure script run from repo root
if [ ! -d ".git" ]; then
  echo "Error: This directory does not appear to be a git repository. Init one or run from repo root."
  exit 1
fi

# Ensure diary directory exists
if [ ! -d "diary" ]; then
  echo "Error: diary/ directory not found. Put your markdown files in diary/ and re-run."
  exit 1
fi

# Ensure on correct branch (create if doesn't exist)
git checkout -B "$BRANCH"

# Optional: set author name/email for these commits (local repo-level)
# Uncomment below lines and edit if you want the commits to have a specific author.
# git config user.name "Your Name"
# git config user.email "you@example.com"

# --- Initial README commit (dated day before training) ---
README_COMMIT_DATE="2025-06-22T${TIME_OF_DAY}"
if git ls-files --error-unmatch README.md >/dev/null 2>&1; then
  git add README.md
  GIT_AUTHOR_DATE="$README_COMMIT_DATE" GIT_COMMITTER_DATE="$README_COMMIT_DATE" \
    git commit --allow-empty -m "Initialize data science training diary repository" || true
else
  echo "README.md not found — skipping README initial commit."
fi

# --- Diary commits mapping: date -> commit message ---
declare -a ENTRIES=(
"2025-06-23|Day 1: Introduction to Data Science"
"2025-06-24|Day 2: Python and Jupyter environment setup"
"2025-06-25|Day 3: Python basics and data types"
"2025-06-26|Day 4: Control flow using conditionals and loops"
"2025-06-27|Day 5: Functions and modular programming in Python"
"2025-06-28|Day 6: Python data structures"
"2025-06-29|Day 7: File handling and CSV processing"
"2025-06-30|Day 8: NumPy fundamentals"
"2025-07-01|Day 9: Advanced NumPy operations"
"2025-07-02|Day 10: Pandas Series and DataFrame basics"
"2025-07-03|Day 11: Data cleaning using Pandas"
"2025-07-04|Day 12: Exploratory Data Analysis"
"2025-07-05|Day 13: Data visualization with Matplotlib and Seaborn"
"2025-07-06|Day 14: EDA and visualization practice"
"2025-07-07|Day 15: Descriptive statistics and distributions"
"2025-07-08|Day 16: Probability concepts and correlation analysis"
"2025-07-09|Day 17: Introduction to machine learning"
"2025-07-10|Day 18: Linear regression modeling"
"2025-07-11|Day 19: Classification using logistic regression and KNN"
"2025-07-12|Day 20: Model evaluation and overfitting"
"2025-07-13|Day 21: Introduction to neural networks"
"2025-07-14|Day 22: Neural network implementation basics"
"2025-07-15|Day 23: Mini project dataset selection and problem definition"
"2025-07-16|Day 24: Data preprocessing and feature engineering"
"2025-07-17|Day 25: Baseline model training"
"2025-07-18|Day 26: Model tuning and comparison"
"2025-07-19|Day 27: Result analysis and limitations"
"2025-07-20|Day 28: Project documentation and report writing"
"2025-07-21|Day 29: Final review and presentation"
)

# --- Commit loop ---
for entry in "${ENTRIES[@]}"; do
  DATE="${entry%%|*}"
  MSG="${entry##*|}"
  FILE="diary/${DATE}.md"
  COMMIT_DATE="${DATE}T${TIME_OF_DAY}"

  if [ -f "$FILE" ]; then
    git add "$FILE"
    echo "Committing $FILE with date $COMMIT_DATE ..."
    GIT_AUTHOR_DATE="$COMMIT_DATE" GIT_COMMITTER_DATE="$COMMIT_DATE" \
      git commit -m "$MSG" || {
        echo "Commit failed for $FILE (maybe already committed). Continuing..."
      }
  else
    echo "Warning: $FILE not found — skipping."
  fi
done

echo "All done locally."

# --- Push (commented out by default) ---
# If you want to push these commits to remote, uncomment the following lines
# and set REMOTE_URL above or ensure origin is configured.

# git remote remove origin 2>/dev/null || true
# git remote add origin "$REMOTE_URL"
# git push -u origin "$BRANCH"

echo "Script finished. If you want these commits on GitHub, set a remote and push:"
echo "  git remote add origin <YOUR_GITHUB_REPO_URL>"
echo "  git push -u origin $BRANCH"
