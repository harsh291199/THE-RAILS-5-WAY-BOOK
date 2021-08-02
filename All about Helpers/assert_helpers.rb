# frozen_string_literal: true

# ----------- AssertTagHelper module ---------------------

# ------ Head helpers -------

# Example: auto_discovery_link_tag
auto_discovery_link_tag
auto_discovery_link_tag(:atom)
auto_discovery_link_tag(:rss, { action: 'feed' })

# Example: favicon_link_tag
fevicon_link_tag '/myicon.ico'

# Example: javascript_include_tag(*sources)
javascript_include_tag 'xmlhr'
javascript_include_tag 'templates.jst', extname: false

# Example: stylesheet_include_tag(*sources)
stylesheet_include_tag 'style'
stylesheet_include_tag 'random.styles', '/css/stylish'


# ------ Asset helpers -------

# Example: audio_tag
audio_tag('sound')
audio_tag('sound.wav', autoplay: true, controls: true)

# Example: image_tag
image_tag('icon.png')
image_tag('photos/dog.jpg', class: 'icon')

# Example: video_tag
video_tag('trailor.ogg', controls: true, autobuffer: true)
video_tag('trail.m4v', size: '16x10', poster: 'screenshot.png')


# ----------- AssertUrlHelper module ---------------------

# ------- assert_path --------
assert_path 'application.js'
assert_path 'application', type: :javascript
assert_path 'application', type: :stylesheet

# ------- assert_url -------
assert_url 'application.js', host: 'http://cdn.example.com'

# --------- audio_path -------
audio_path('horse')
# => /audios/horse
audio_path('sounds/horse.wav')
# => /sounds/horse.wav

# --------- font_path -------
font_path('font.ttf')
font_path('dir/font.ttf')

# --------- image_path -------
image_path('edit.png')
image_path('icons/edit.png')

# --------- javasrcipt_path -------
javascript_path 'xmlhr'
javascript_path 'dir/xmlhr.js'
javascript_path 'http://www.example.com/js/xmlhr.js'

# --------- stylesheet_path ---------
stylesheet_path 'style'
stylesheet_path 'dir/style.css'
stylesheet_path 'http://www.example.com/css/style'

# --------- video_path ---------
video_path('hd')
video_path('trailers/hd.avi')
video_path('http://www.example.com/vid/hd.avi')


# ----------- AtomFeedHelper ---------------------

# Example:
atom_feed do |feed|
  feed.title('My great dog')
  feed.updated(@photos.first.created_at)

  @posts.each do |post|
    feed.entry(post) do |entry|
      entry.title(post.title)
      entry.content(post.body, type: 'html')

      entry.author do |author|
        author.name('DHH')
      end
    end
  end
end

# ----------- CaptureHelper ---------------------

# ---- capture(&block) --------

# - message_html = capture do
#   %div
#     This is a message
# end

# ---- content_for(name, &block) -----

# - content_for :navigation_sidebar do
#   = link_to 'Detail page', item_detail_path(item)
# end

# ----- content_for?(name) -----

# %body{class: content_for?(:right_col) ? 'one-column' : 'two-column'}
#   = yield
#   = yield :right_col


# ----------- The Date and Time Selection Helpers -------------

# Example: date_select
date_select(:post, 'written_on')
date_select(:post, 'written_on', start_year: 1995,
                                 use_month_numbers: true,
                                 discard_day: true,
                                 include_blank: true)

# Example: datetime_select
datetime_select('post', 'written_on')
datetime_select('post', 'written_on', ampm: true)

# Example: time_select
time_select('post', 'sunrise')
time_select('post', 'written_on', include_seconds: true)