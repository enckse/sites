BIN     := bin/
RESUME  :=$(BIN)/resume.tex
ADDRESS :=
PHONE   :=
TODAY   := $(shell date +%Y-%m-%d)
PDF     := $(BIN)resume.pdf
TEX     := resume.tex

all: $(PDF)

$(PDF): $(RESUME)
	xelatex -interaction nonstopmode -output-directory=$(BIN) $(RESUME)

$(RESUME): $(TEX)
ifeq ($(ADDRESS),)
	$(error "address required")
endif
ifeq ($(PHONE),)
	$(error "phone required")
endif
	mkdir -p $(BIN)
	cat $(TEX) | sed "s/{PHONE}/$(PHONE)/g;s/{ADDRESS}/$(ADDRESS)/g;s/{DATE}/$(TODAY)/g" > $(RESUME)

clean:
	rm -rf $(BIN)
