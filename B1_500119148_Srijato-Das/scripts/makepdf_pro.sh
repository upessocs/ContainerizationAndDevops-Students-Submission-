#!/bin/bash

# ==============================================================================
# Professional DevOps Lab PDF Generator (Academic Version)
# Purpose: Converts Local Markdown Labs to a High-Fidelity PDF Report
# ==============================================================================

LOG_FILE="pdf_generator.log"
OUTPUT_PDF="DevOps_Lab_Report.pdf"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Ensure we are in the script's directory
cd "$(dirname "$0")/.." || exit 1

exec > >(tee -a "$LOG_FILE") 2>&1

echo "----------------------------------------------------------------"
echo "Starting Academic PDF Generation at $TIMESTAMP"
echo "----------------------------------------------------------------"

error_exit() {
    echo "[ERROR] $1" >&2
    exit 1
}

# --- 1. Dependency Check ---
echo "[1/4] Verifying Dependencies..."
command -v pandoc >/dev/null 2>&1 || error_exit "Pandoc is not installed."
command -v xelatex >/dev/null 2>&1 || error_exit "XeLaTeX (texlive-xetex) is not installed."
command -v curl >/dev/null 2>&1 || error_exit "Curl is not installed."

# --- 2. Static Metadata ---
AUTHOR="SRIJATO DAS"
SAPID="500119148"
ENROLLMENT="R2142230488"
BATCH="B1 CCVT"
FACULTY="Dr. Prateek Raj Gautam"

# --- 3. Badge Pre-download ---
echo "[2/4] Downloading Tech Badges..."
mkdir -p .build_temp/badges
declare -A BADGES
BADGES["git"]="https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white"
BADGES["github"]="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white"
BADGES["docker"]="https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white"
BADGES["jenkins"]="https://img.shields.io/badge/jenkins-%23D24939.svg?style=for-the-badge&logo=jenkins&logoColor=white"
BADGES["ansible"]="https://img.shields.io/badge/ansible-%23EE0000.svg?style=for-the-badge&logo=ansible&logoColor=white"
BADGES["sonarqube"]="https://img.shields.io/badge/sonarqube-%234781eb.svg?style=for-the-badge&logo=sonarqube&logoColor=white"
BADGES["kubernetes"]="https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white"
BADGES["ubuntu"]="https://img.shields.io/badge/ubuntu-%23E95420.svg?style=for-the-badge&logo=ubuntu&logoColor=white"

for name in "${!BADGES[@]}"; do
    if [ ! -s ".build_temp/badges/$name.svg" ]; then
        curl -L -f -s -o ".build_temp/badges/$name.svg" "${BADGES[$name]}" || echo "[WARN] Failed to download $name badge."
    fi
done

# --- 4. Local File Collection & Sanitization ---
echo "[3/4] Collecting & Sanitizing Lab Files..."

sanitize_file() {
    local src="$1"
    local dest=".build_temp/$(basename "$src")"
    perl -pe 's/[\x00-\x08\x0B\x0C\x0E-\x1F]//g' "$src" | \
    sed "s|https://img.shields.io/badge/git-[^)]*|.build_temp/badges/git.svg|g" | \
    sed "s|https://img.shields.io/badge/github-[^)]*|.build_temp/badges/github.svg|g" | \
    sed "s|https://img.shields.io/badge/docker-[^)]*|.build_temp/badges/docker.svg|g" | \
    sed "s|https://img.shields.io/badge/jenkins-[^)]*|.build_temp/badges/jenkins.svg|g" | \
    sed "s|https://img.shields.io/badge/ansible-[^)]*|.build_temp/badges/ansible.svg|g" | \
    sed "s|https://img.shields.io/badge/sonarqube-[^)]*|.build_temp/badges/sonarqube.svg|g" | \
    sed "s|https://img.shields.io/badge/kubernetes-[^)]*|.build_temp/badges/kubernetes.svg|g" | \
    sed "s|https://img.shields.io/badge/ubuntu-[^)]*|.build_temp/badges/ubuntu.svg|g" > "$dest"
    echo "$dest"
}

FILES=()
[ -f "README.md" ] && FILES+=($(sanitize_file "README.md"))

for i in {0..12}; do
    FILE=$(ls Lab/Experiment_${i}_*.md Lab/Experiment_${i}-*.md 2>/dev/null | head -n 1)
    [[ ! -f "$FILE" ]] && FILE=$(ls Lab/Experiment_${i}*.md 2>/dev/null | head -n 1)
    if [[ -f "$FILE" ]]; then
        echo "Processing: $FILE"
        FILES+=($(sanitize_file "$FILE"))
    fi
done

# --- 5. Custom LaTeX Header & Title Page ---
echo "[4/4] Preparing Academic Formatting..."

LOCAL_LOGO="UPES_Logo.jpg"
SAFE_LOGO="upes_logo_clean.jpg"
USE_LOGO="false"

if [ -s "$LOCAL_LOGO" ]; then
    cp "$LOCAL_LOGO" "$SAFE_LOGO"
    USE_LOGO="true"
    LOGO_FILE="$SAFE_LOGO"
else
    LOGO_URL="https://www.upes.ac.in/media/1001/upes-logo.png"
    if [ ! -s "upes_logo.png" ]; then
        curl -L -f -s -o upes_logo.png "$LOGO_URL"
    fi
    if [ -s "upes_logo.png" ]; then
        USE_LOGO="true"
        LOGO_FILE="upes_logo.png"
    fi
fi

# Build Title Page
cat <<'EOF' > title_page.tex
\begin{titlepage}
    \centering
    \vspace*{1.5cm}
EOF

if [ "$USE_LOGO" = "true" ]; then
    echo "    \includegraphics[width=0.55\textwidth]{$LOGO_FILE}\\\\[2cm]" >> title_page.tex
else
    echo "    {\huge \bfseries UNIVERSITY OF PETROLEUM \& ENERGY STUDIES \par}\\\\[2cm]" >> title_page.tex
fi

cat <<'EOF' >> title_page.tex
    \vspace*{1cm}
    {\Large \bfseries Containerization \& DevOps Lab \par}
    \vspace*{2cm}
    
    {\Large \bfseries Laboratory Portfolio \par}
    \vspace*{1.5cm}
    
    \begin{center}
    \LARGE
    \renewcommand{\arraystretch}{1.6}
    \begin{tabular}{ll}
EOF

echo "    \textbf{Name:} & $AUTHOR \\\\" >> title_page.tex
echo "    \textbf{SAP ID:} & $SAPID \\\\" >> title_page.tex
echo "    \textbf{Enrollment No:} & $ENROLLMENT \\\\" >> title_page.tex
echo "    \textbf{Batch:} & $BATCH \\\\" >> title_page.tex
echo "    \textbf{Faculty Name:} & $FACULTY \\\\" >> title_page.tex

cat <<'EOF' >> title_page.tex
    \end{tabular}
    \end{center}
    
    \vfill
\end{titlepage}
\newpage
EOF

cat <<'EOF' > header.tex
\usepackage{fvextra}
\DefineVerbatimEnvironment{Highlighting}{Verbatim}{commandchars=\\\{\},breaklines}
\usepackage{longtable,booktabs,array}
\usepackage{etoolbox}
\usepackage{graphicx}
\usepackage{fontspec}
\newcommand{\hr}[1][1pt]{\rule{\linewidth}{#1}}

\setmonofont{DejaVu Sans Mono}
\setmainfont{Liberation Serif}

\preto{\section}{\newpage}
\AtBeginEnvironment{longtable}{\small}

\makeatletter
\def\maxwidth{\ifdim\Gin@nat@width>\linewidth\linewidth\else\Gin@nat@width\fi}
\makeatother
\let\Oldincludegraphics\includegraphics
\renewcommand{\includegraphics}[2][]{\Oldincludegraphics[width=\maxwidth]{#2}}
EOF

# --- 6. PDF Generation ---
echo "[4/4] Generating Academic Report..."
pandoc "${FILES[@]}" \
    -o "$OUTPUT_PDF" \
    --pdf-engine=xelatex \
    --include-before-body=title_page.tex \
    --include-in-header=header.tex \
    --toc \
    --number-sections \
    --resource-path=".:Lab:Asset:.build_temp/badges" \
    -f markdown+hard_line_breaks \
    -V geometry:margin=0.8in \
    -V linkcolor:blue

# Cleanup
if [ -f "$OUTPUT_PDF" ]; then
    rm -f header.tex title_page.tex upes_logo_clean.jpg
    rm -rf .build_temp
    echo "----------------------------------------------------------------"
    echo "SUCCESS: Academic Report generated as '$OUTPUT_PDF'."
    echo "----------------------------------------------------------------"
else
    error_exit "PDF generation failed. Check log file for details."
fi
