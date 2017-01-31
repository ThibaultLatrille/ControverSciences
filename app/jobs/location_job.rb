class LocationJob
  include SuckerPunch::Job

  def perform(suggestion_id,suggestion_child_id,
              user_id,   ip_address,user_agent)
    ApplicationRecord.connection_pool.with_connection do
      Location.create(user_id: user_id,
                             suggestion_id: suggestion_id,
                             suggestion_child_id: suggestion_child_id,
                             user_agent: user_agent,
                             ip_address: ip_address
      )
    end
  end
end
