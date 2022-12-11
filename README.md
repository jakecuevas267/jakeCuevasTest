# jakeCuevasTest

Coding assignment for Perch Energy

This assignment assumes that a Subscription has to both a Customer and a Solar System attached to it. 

The Subscription is the child object of a Master Detail Relationship to both Solar System and Customer. This makes both Customer and Solar System required on the Subscription object. Solar Systems can have multiple Subscriptions but a Solar System can only have one Active Subscription at a time. A Customer can have many Subscriptions which tie it to many Solar Systems. A Subscription can only have one of each Customer and Solar System.

Fields and Objects:

Subscription:
  Start Date 
  , End Date
  , Status (Active/Inactive)
  , Customer
  , Solar System
  
Solar System:
  Subscription Start Date 
  , Subscription End Date
  , Active (Boolean)


The SubscriptionEffectiveDate_Batch() will be scheduled before the workday starts every day. Likely 3-4AM.

If a subscription reaches its Start or End Date, the SubscriptionEffectiveDate_Batch() will activate/deactivate the subscription.

The Handler_Subscription will then take care of validating the Subscription and updating the related Solar System.

The Handler_Subscription will also take care of automating updates to the Subscription/Solar System.

  Example: If the Status is set to active on a Subscription but the dates do not reflect the Status change, the status will flip back.
