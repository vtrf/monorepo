package mataroa

type PostFrontmatter struct {
	Title       string `yaml:"title"`
	Slug        string `yaml:"slug"`
	PublishedAt string `yaml:"published_at"`
}

type PostsCreateResquest struct {
	Body        string `json:"body,omitempty"`
	PublishedAt string `json:"published_at,omitempty"`
	Title       string `json:"title,omitempty"`
}

type PostsBaseResponse struct {
	OK    bool   `json:"ok,omitempty"`
	Error string `json:"error"`
}

type PostsCreateResponse struct {
	PostsBaseResponse
	Slug string `json:"slug,omitempty"`
	URL  string `json:"url,omitempty"`
}

type PostsUpdateResponse struct {
	PostsBaseResponse
	Slug string `json:"slug,omitempty"`
	URL  string `json:"url,omitempty"`
}

type PostsDeleteResponse struct {
	PostsBaseResponse
}

type PostsListResponse struct {
	PostsBaseResponse
	PostList []Post `json:"post_list,omitempty"`
}

type PostsGetResponse struct {
	PostsBaseResponse
	Post
}
