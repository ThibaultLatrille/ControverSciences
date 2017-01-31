class Domain < ApplicationRecord
  validates :name, :exclusion => { :in => ["aol.com", "att.net", "comcast.net", "facebook.com", "gmail.com", "gmx.com", "googlemail.com",
                                           "google.com", "hotmail.com", "hotmail.co.uk", "mac.com", "me.com", "mail.com", "msn.com",
                                           "live.com", "sbcglobal.net", "verizon.net", "yahoo.com", "yahoo.co.uk",
                                           "hotmail.fr", "live.fr", "laposte.net", "yahoo.fr", "wanadoo.fr", "orange.fr", "gmx.fr", "sfr.fr", "neuf.fr", "free.fr"],
                                        :message => "Subdomain %{value} is reserved." }
end
