ifeq ($(PREFIX),)
	PREFIX := /usr/local
endif
ODIR=output
PAGES_SRC := $(wildcard content/pages/*)
PAGES_DST := $(patsubst content/pages/%,$(ODIR)/%/index.html,$(PAGES_SRC))

PROJECTS_SRC := $(wildcard content/projects/*)
PROJECTS_DST := $(patsubst content/projects/%,$(ODIR)/projects/%/index.html,$(PROJECTS_SRC))

POSTS_SRC := $(wildcard content/posts/*)
POSTS_DST := $(patsubst content/posts/%,$(ODIR)/posts/%/index.html,$(POSTS_SRC))

all: $(PAGES_DST) $(PROJECTS_DST) $(POSTS_DST) $(ODIR)/style.css $(ODIR)/favicon.ico $(ODIR)/index.html $(ODIR)/posts/index.html $(ODIR)/rss.xml

$(ODIR)/%/index.html: content/pages/%/note.md
	mkdir -p "$(dir $@)"
	cat "$<" | ./bin/mdpage.sh --notitle > "$@"

$(ODIR)/projects/%/index.html: content/projects/%/note.md
	mkdir -p "$(dir $@)"
	cat "$<" | ./bin/mdpage.sh > "$@"

$(ODIR)/posts/%/index.html: content/posts/%/note.md
	mkdir -p "$(dir $@)"
	cat "$<" | ./bin/mdpage.sh > "$@"
	rsync -rupE --exclude="note.md" "$(dir $<)" "$(dir $@)"


$(ODIR)/posts/index.html: $(POSTS_SRC)
	mkdir -p "$(dir $@)"
	./bin/toc.sh content/posts "/posts" | cat content/index.md - | awk -f ./bin/markdown.awk | ./bin/page.sh Posts > "$@"

$(ODIR)/rss.xml: $(POSTS_SRC)
	./bin/rss.sh content/posts "https://vmatveeva.com" "/posts" > "$@"

$(ODIR)/index.html: content/index.md
	./bin/toc.sh content/posts "/posts" | cat content/index.md - | awk -f ./bin/markdown.awk | ./bin/page.sh "Valeriya Matveeva" > "$@"

$(ODIR)/style.css: style.css
	cp style.css $(ODIR)/style.css

$(ODIR)/favicon.ico: favicon.ico
	cp favicon.ico $(ODIR)/favicon.ico

clean:
	rm -rf $(ODIR)/*

install:
	install -d $(DESTDIR)$(PREFIX)/srv/vmatveeva.com
	rsync -av --no-o --no-g output/ $(DESTDIR)$(PREFIX)/srv/vmatveeva.com
