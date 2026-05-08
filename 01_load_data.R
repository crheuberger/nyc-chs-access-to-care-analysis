# =========================
# Load CHS SAS Data
# =========================

# Install package (only run this ONCE)
install.packages("haven")

# Load the package (run every time)
library(haven)

# Load the CHS dataset
chs <- read_sas("C:/Users/ClaireHeuberger/OneDrive - Community Health Care Association of New York State/Microsoft Teams Data/Documents/CHS Survey Project/chs2020_public.sas7bdat")

# Check it loaded correctly
str(chs)

