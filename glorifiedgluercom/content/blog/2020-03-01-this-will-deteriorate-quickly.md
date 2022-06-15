---
title: "This will deteriorate quickly"
slug: "this-will-deteriorate-quickly"
date: "2020-03-01"
summary: |
  Thoughts about the current state of the web, content consuming and its longevity.
---

In my teenager years I was a member of my school's student council. Part of our
job was to propose changes to our current infrastructure, organize study groups
and plan social projects. We were a bunch of youngsters without much experience
– or no experience at all – in the education field, therefore we resorted to
know from those who had it over the Internet. At the time there wasn't a lot of
content about it on social media, the majority was writing at Blogspot (now
[Blogger](https://blogger.com)) or forums.

Here comes [RSS](https://pt.wikipedia.org/wiki/RSS). Blogspot offered a **RSS
Feed** by default so it was rather simple to follow dozens of blogs. Every
member of the council used a RSS reader they liked the most and it worked
great.

Years passed and I found the list of blogs I used to read at that time. While
diving through the links I found out most of them didn't receive an update
since my highschool (or have just disappeared). However, they always had a link
to the author's social media (Twitter, Facebook or LinkedIn) and you could see
those profiles were being updated regularly. A lot of the educators continued
to write posts about their field of interest, but now on social media.

In the meantime, I observed a pattern between profiles. They tended to
reference their old posts from the Blogger platform instead of publishing them
again on the new platform. Why so? You could see some of them tried to do that
but formatting was awkward as Facebook doesn't provide the same tools Blogger
offered and Twitter's posts are too short. So I feel they just couldn't
retrieve their posts and they were long gone from their hands.

So how would an individual escape this madness? It's quite simple, a blog post
is nothing but static content. Text, images videos and audios. Use this in your
favor. Write text on known formats such as Markdown[^1],
[ReStructuredText](https://pt.wikipedia.org/wiki/ReStructuredText) or even
plain-text. Store all files in a [Git](https://git-scm.com) repository,
external hard drive, Dropbox… whatever. Just stick to the simplest file formats
and reliable storage. Services like [Medium](https://medium.com),
[Substack](https://substack.com) and [Tumblr](https://tumblr.com) can die and
take all your posts with them at any time.

At the moment I'm using [Neovim](https://neovim.io) to edit my blog posts in
Markdown and hosting them in [mataroa](mataroa.blog). Alternatives are:
[Hugo](https://gohugo.io), [Zola](https://getzola.org) and more. All you need
to setup a web site is one of these programs, a bunch of Markdown files and a
web server. You'll also find a lot of places to host your content for free such
as [GitLab](https://gitlab.com), [GitHub](https://github.com) or
[Netlify](https://netlify.com).

Although this approach brings some advantages, it has some shortcomings too. In
a static website you won't have a comments section without a third-party
service; basic tech knowledge is needed to know where to put files in your web
server provider of choice and if you want a custom domain such as this one
you'll have to do some configuration. A quick YouTube tutorial might be
sufficient to teach you how to do all of the above in minutes.

[^1]: Even better if following a specification such as
  [https://commonmark.org/](https://commonmark.org/)
