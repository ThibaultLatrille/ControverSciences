class IssuesController < ApplicationController
  def create
    issue = Issue.new(issue_params)
    issue.labels = params[:issue][:labels].blank? ? ["unset-label"] : params[:issue][:labels]
    if params[:issue][:importance].blank?
      issue.labels << "unset-importance"
    else
      issue.labels << params[:issue][:importance]
    end
    issue.title.blank? ? issue.title = "Unset" : nil
    issue.body += "\n Sur la page " + issue.url + "\n Par : " + issue.author + "\n Navigateur : " + browser.to_s
    if issue.save
      respond_to do |format|
        format.js { render 'issue/success', :content_type => 'text/javascript', :layout => false}
      end
    else
      redirect_to root_path
    end
  end

  private

  def issue_params
    params.require( :issue ).permit( :title, :body, :author, :url )
  end
end
