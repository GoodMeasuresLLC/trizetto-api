## 0.2.0 (January 18, 2018) ##

* Make it simple to answer the question: does this person have insurance
  coverage via the WebService Eligibility check.  The raw XML response is parsed
  into plain old ruby objects.
* Added tests (woo hoo)
* Readme update with examples
* Documented the WebService Eligibility check

## 0.1.2 (January 12, 2018) ##

* Have the non-COR II Eligiblity check return an XML document.  YAY! We can
  parse and understand XML without having to understand X12.

## 0.1.1 (January 11, 2018) ##

* Initial implementation of 5 Trizetto API endpoints: Eligibility check with
  CORE II, Eligibility check via web service, ping the service, download the
  payer list, and get a document link to an enrollment form.
* Current implementation is just a thin wrapper - you will have to parse the result
* No X12 serialization/deserization yet - you must craft and decode X12 messages
  to use the eligibility API
* The payer list endpoint seems to either timeout or error on the Trizetto Server

