class Issue < ActiveRecord::Base
  after_create :git_hub_api

  private

  def git_hub_api
    client = Octokit::Client.new( :access_token => ENV["GIT_HUB_TOKEN"] )
    client.create_issue("ThibaultLatrille/ControverSciences",
                        self.title,
                        self.body,
                        labels: self.labels)
  end
end
