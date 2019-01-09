# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://controversciences.org"
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
    aws_access_key_id: ENV['S3_ACCESS_KEY'],
    aws_secret_access_key: ENV['S3_SECRET_KEY'],
    fog_provider: 'AWS',
    fog_directory: ENV['S3_BUCKET'],
    fog_region: 'eu-central-1'
)
SitemapGenerator::Sitemap.sitemaps_host = "http://controversciences.s3.amazonaws.com/"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  add '/about', changefreq: 'weekly'
  Timeline.where(private: false).where(staging: false).find_each do |timeline|
    add timeline_path(timeline), lastmod: timeline.updated_at
  end
  Reference.find_each do |reference|
    add reference_path(reference), lastmod: reference.updated_at
  end
  User.where(activated: true).find_each do |user|
    add user_path(user), lastmod: user.updated_at
  end
  Comment.where(public: true).find_each do |comment|
    add comment_path(comment), lastmod: comment.updated_at
  end
  Summary.where(public: true).find_each do |summary|
    add summary_path(summary), lastmod: summary.updated_at
  end
end

SitemapGenerator::Sitemap.ping_search_engines