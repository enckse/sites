BIN     := bin/
RESUME  :=$(BIN)resume.tex
ADDRESS :=
PHONE   :=
TODAY   := $(shell date +%Y-%m-%d)
PDF     := $(BIN)resume.pdf
TEX     := resume.tex.in
DEPS    := apk add texlive-xetex texlive-full

all: $(PDF)

deps:
	$(DEPS)

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
	m4 --define=ADDRESS=$(ADDRESS) --define=PHONE=$(PHONE) --define=TODAY=$(TODAY) $(TEX) > $(RESUME)

clean:
	rm -rf $(BIN)
