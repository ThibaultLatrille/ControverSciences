class IssuesController < ApplicationController
  def create
    issue = Issue.new(issue_params)
    issue.labels = params[:issue][:labels] << params[:issue][:importance]
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
