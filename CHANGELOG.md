## 0.1.1 (January 11, 2018) ##

* Initial implementation of 5 Trizetto API endpoints: Eligibility check with
  CORE II, Eligibility check via web service, ping the service, download the
  payer list, and get a document link to an enrollment form.
* Current implementation is just a thin wrapper - you will have to parse the result
* No X12 serialization/deserization yet - you must craft and decode X12 messages
  to use the eligibility API
* The payer list endpoint seems to either timeout or error on the Trizetto Server

