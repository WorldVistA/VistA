HTML := $(patsubst %.rst,%.html,$(wildcard *.rst))

%.html:	%.rst
	pandoc --toc --eol=lf $< -f rst -t html5 --template template.html5 -o $@
all: $(HTML)
clean:
	rm *.html
