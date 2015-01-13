class IssuesController < ApplicationController
  def create
    issue = Issue.new(issue_params)
    issue.labels = params[:issue][:labels] << params[:issue][:importance]
    issue.body += "\n Sur la page " + issue.url + "\n Par : " + issue.author + "\n Navigateur : " + browser.to_s
    if issue.save
      render 'issue/success'
    else
      redirect_to root_path
    end
  end

  private

  def issue_params
    params.require( :issue ).permit( :title, :body, :author, :url )
  end
end
