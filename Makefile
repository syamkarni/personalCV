# Typst executable
TYPST = typst

# Source file
SOURCE = main.typ

# Output file
OUTPUT = resume.pdf

# Typst compile command
TYPST_CMD = $(TYPST) compile $(SOURCE) $(OUTPUT)

# Default target
all: $(OUTPUT)

# Rule to compile the resume into PDF
$(OUTPUT): $(SOURCE) main.typ
	$(TYPST_CMD)

# Clean target
clean:
	rm -f $(OUTPUT)

# Watch for changes and automatically recompile
watch:
	$(TYPST) watch $(SOURCE) main.typ --open

# Print commands for debugging
print-%:
	@echo '$*=$($*)'