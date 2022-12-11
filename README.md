# jakeCuevasTest

Coding assignment for Perch Energy

This assignment assumes that a Subscription has to both a Customer and a Solar System attached to it. 

A Customer can have multiple Subscriptions and a Solar System can also have multiple Subscriptions. 

A Solar System can only have one Active Subscription at a time. 

Fields and Objects:

Subscription:
  Start Date
  End Date
  Status (Active/Inactive)
  Customer
  Solar System
  
Solar System
  Subscription Start Date
  Subscription End Date
  Active (Boolean)



The SubscriptionEffectiveDate_Batch() will be scheduled before the workday starts every day. Likely 3-4AM.

If a subscription reaches its Start or End Date, the SubscriptionEffectiveDate_Batch() will activate/deactivate the subscription.

The Handler_Subscription will then take care of validating the Subscription and updating the related Solar System.

The Handler_Subscription will also take care of automating updates to the Subscription/Solar System.

  Example: If the Status is set to active on a Subscription but the dates do not reflect the Status change, the status will flip back.
