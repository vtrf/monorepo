mata(1)

# NAME

mata - A CLI companion for mataroa.blog

# SYNOPSIS

*mata* [commands...] [options...]

# DESCRIPTION

mata is a CLI companion utility to interact with mataroa.blog.

# OPTIONS

*-h*, *--help*
	Show help message and quit.
	Can be used after a command to get more information it.

# COMMANDS

*init*
	Initialize mata's configuration file.

*help* <command>
	Help about any command.

*sync*
	Sync all your posts.

	Options are:

	*-d*, *--directory* <path>
		Directory containing blog posts. (default ".")

## posts, p

*create*, *c* <file>
	Create a post.

*delete*, *d* <slug>
	Delete a post.

*edit*, *e* <slug>
	Edits a post by opening it on yout $EDITOR.

*get*, *g* <slug>
	Get a post.

	Options are:

	*--json*
		Output JSON

*list*, *l* <slug>
	List all posts.

	Options are:

	*--json*
		Output JSON

*update*, *u* <file>
	Update a post.

	Options are:

	*--slug* <slug>
		Post slug

# CONFIGURATION

There is only one configuration file for mata: *config.json*. The program looks 
after this file in your XDG config home plus "mata", which defaults to 
~/.config/mata or the path on *MATAROA_CONFIG*. This file uses the _json_ format.

Another way to configure the CLI is to set the respective *MATAROA_ENDPOINT* and
*MATAROA_KEY* environment variables. If both variables are set, the program will
skip reading the *config.json* file. This is useful to use this tool in a 
Continuous Integration environment.

## CONFIG.JSON

This file is used to configure the behavior of mata.

*endpoint*
	Sets the endpoint that will be used to send resquests.

	Default: https://mataroa.blog/api

*key*
	The API key provided by your mataroa dashboard.

# AUTHORS

Created by Victor Freire <victor@freire.dev.br>. For more information about mata
development, see https://sr.ht/~glorifiedgluer/mata.
