[1mdiff --git a/app/controllers/user_details_controller.rb b/app/controllers/user_details_controller.rb[m
[1mindex 6ba69405..57ef112c 100644[m
[1m--- a/app/controllers/user_details_controller.rb[m
[1m+++ b/app/controllers/user_details_controller.rb[m
[36m@@ -31,6 +31,18 @@[m [mclass UserDetailsController < ApplicationController[m
     end[m
   end[m
 [m
[32m+[m[32m  def unsuscribe[m
[32m+[m[32m    u = User.find_by(email: params[:email])[m
[32m+[m[32m    if u[m
[32m+[m[32m      flash[:success] = "Vous avez bien été désabonné."[m
[32m+[m[32m      UserDetail.where(id: u.id).update_all(send_email: false, frequency: 0)[m
[32m+[m[32m      redirect_to user_path(u)[m
[32m+[m[32m    else[m
[32m+[m[32m      flash[:danger] = "Cette adresse email n'existe pas."[m
[32m+[m[32m      redirect_to_home[m
[32m+[m[32m    end[m
[32m+[m[32m  end[m
[32m+[m
   private[m
 [m
   def user_detail_params[m
[1mdiff --git a/app/views/likes/index.html.erb b/app/views/likes/index.html.erb[m
[1mindex fa0d0700..185e8d2b 100644[m
[1m--- a/app/views/likes/index.html.erb[m
[1m+++ b/app/views/likes/index.html.erb[m
[36m@@ -18,7 +18,7 @@[m
                   <br/>[m
 		  <%= t('views.likes.clic_on') %>[m
 		  <button type="button" class="btn btn-success">[m
[31m-                    <span class="glyphicon glyphicon-thumbs-up"></span>[m
[32m+[m[32m                     Abonnement[m
                   </button>[m
 		  <%= t('views.likes.get_notified') %>[m
 		  <br/>[m
[1mdiff --git a/app/views/user_mailer/notifications.html.erb b/app/views/user_mailer/notifications.html.erb[m
[1mindex 18786d0b..06a70412 100644[m
[1m--- a/app/views/user_mailer/notifications.html.erb[m
[1m+++ b/app/views/user_mailer/notifications.html.erb[m
[36m@@ -106,6 +106,12 @@[m
                           <%= t('views.mailer.the_team') %></a> <%= t('views.mailer.notif_wish') %>[m
                       </td>[m
                     </tr>[m
[32m+[m[32m                    <tr>[m
[32m+[m[32m                      <td style="font-family: Roboto-Regular,Helvetica,Arial,sans-serif; font-size: 13px; color: #202020; line-height: 1.5;">[m
[32m+[m[32m                        <a style="text-decoration: none;color:#454545;border-bottom: 1px dotted#454545" href='<%= unsuscribe_email_url(email: @user_notif.email) -%>'>[m
[32m+[m[32m                          Se désabonner </a>[m
[32m+[m[32m                      </td>[m
[32m+[m[32m                    </tr>[m
                     <tr height="16px"></tr>[m
                   </table>[m
                 </td>[m
[1mdiff --git a/config/routes.rb b/config/routes.rb[m
[1mindex 73ac7ff9..57a1805a 100644[m
[1m--- a/config/routes.rb[m
[1m+++ b/config/routes.rb[m
[36m@@ -158,6 +158,7 @@[m [mRails.application.routes.draw do[m
   get 'my_items/votes'[m
   get "/fetch_children" => 'suggestion_children#from_suggestion', as: 'fetch_children'[m
   get 'feed' => 'timelines#feed', :as => "feed"[m
[32m+[m[32m  get 'unsuscribe_email' => 'user_details#unsuscribe', as: 'unsuscribe_email'[m
   if Rails.env.development?[m
     get '/public/uploads/:file', to: redirect { |path_params, req|[m
       "/uploads/#{path_params[:file]}.#{path_params[:format]}"[m
