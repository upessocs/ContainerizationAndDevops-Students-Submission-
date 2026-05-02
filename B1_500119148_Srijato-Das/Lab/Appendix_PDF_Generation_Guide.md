# Guide: Converting GitHub Pages to PDF

This guide provides a professional methodology for converting your GitHub Pages lab portfolio into a single, high-fidelity PDF document for LMS submission using **Pandoc**.

---

## 1. Installation of Dependencies

Before running the generator script, ensure your environment has the necessary conversion engines installed.

### **For WSL / Ubuntu (Recommended)**
```bash
sudo apt update
sudo apt install pandoc -y
sudo apt install texlive-xetex texlive-latex-recommended texlive-latex-extra -y
```

### **For macOS**
```bash
brew install pandoc
brew install --cask mactex
```

---

## 2. Using the Professional Generator Script

We have provided a robust script located at `scripts/makepdf_pro.sh` that handles metadata, logging, and error detection.

### **Features:**
- **Automated Logging:** Saves activity to `pdf_generator.log`.
- **Metadata Injection:** Promptly asks for your Name and SAP ID for the PDF cover page.
- **URL Validation:** Checks if the provided URLs are reachable.
- **Order Control:** Ensures the Table of Contents follows the sequence of your added URLs.

### **Execution Steps:**

1.  **Navigate to the repository root.**
2.  **Make the script executable:**
    ```bash
    chmod +x scripts/makepdf_pro.sh
    ```
3.  **Run the script:**
    ```bash
    ./scripts/makepdf_pro.sh
    ```

---

## 3. Important Notes for Submission

- **Order Matters**: Input your **Index URL** first, followed by the experiment URLs in chronological order (Exp 0 to Exp 12).
- **Public Accessibility**: Your GitHub Pages site must be set to **Public** for Pandoc to fetch the content.
- **Output**: The script generates a file named `DevOps_Lab_Report.pdf`. Verify the content before uploading it to the LMS.

---

## 4. Troubleshooting

If the script fails:
- Check `pdf_generator.log` for specific LaTeX compilation errors.
- Ensure you have a stable internet connection for Pandoc to download image assets.
- Verify that `xelatex` is correctly installed by running `xelatex --version`.
