package mataroa

import (
	"fmt"
	"strings"
	"time"

	"github.com/adrg/frontmatter"
)

var (
	ISO8601Layout = "2006-01-02"
)

type Post struct {
	Title       string `json:"title,omitempty"`
	Slug        string `json:"slug,omitempty"`
	Body        string `json:"body,omitempty"`
	PublishedAt string `json:"published_at,omitempty"`
	URL         string `json:"url,omitempty"`
}

func NewPost(content []byte) (Post, error) {
	var metadata PostFrontmatter
	body, err := frontmatter.Parse(strings.NewReader(string(content)), &metadata)
	if err != nil {
		return Post{}, fmt.Errorf("error parsing markdown file frontmatter: %s", err)
	}

	if metadata.Title == "" {
		return Post{}, fmt.Errorf("post missing 'title' attribute")
	}

	if metadata.Slug == "" {
		return Post{}, fmt.Errorf("post missing 'slug' attribute")
	}

	var publishedAt string
	if metadata.PublishedAt != "" {
		t, err := time.Parse(ISO8601Layout, metadata.PublishedAt)
		if err != nil {
			return Post{}, fmt.Errorf("post contains invalid date format '%s' should be '%s' format",
				metadata.PublishedAt,
				ISO8601Layout,
			)
		}
		publishedAt = t.Format(ISO8601Layout)
	} else {
		publishedAt = ""
	}

	return Post{
		Body:        string(body),
		PublishedAt: publishedAt,
		Slug:        metadata.Slug,
		Title:       metadata.Title,
	}, nil
}

func (p Post) ToMarkdown() string {
	return fmt.Sprintf(`---
title: "%s"
slug: "%s"
published_at: "%s"
---
%s`,
		p.Title,
		p.Slug,
		p.PublishedAt,
		p.Body,
	)
}

func HasPostChanged(old, new Post) bool {
	return old.Body == new.Body &&
		old.PublishedAt == new.PublishedAt &&
		old.Slug == new.Slug &&
		old.Title == new.Title
}
