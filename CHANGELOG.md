## 0.2.3 (Feb 02, 2018) ##

* Add helpers for extracting the group number and plan number from either a
  subscriber or dependent node in the response.  As a remdiner, the patient is
  the dependent if present, or the subscriber.  Depending on the payer, the
  group number might be in the subscriber or in the dependent, you can't rely
  on it being in the subscriber 100%.  You need to check both, starting with the
  dependent to get the group number. `dependent&.group_number || subscriber&.group_number`
* Parse subscriber additional information (subscriberaddinfo) into the patient
  note.  For some payers, they put subscriberaddinfo in the dependent, so its
  present in both subscribers and dependents.
* Turn the subscriberid node into an id.  This seems to be the member number for
  the insurance so make it easy to get

## 0.2.2 (January 19, 2018) ##

* The response from the DoInquiry eligiblity check now captures the raw XML and
  can be recreated from stored XML.
* Traces are available as part of the DoInquiry eligibility response.  Trizetto
  adds a trace_id ("99Trizetto") and a trace_number to each request that can be
  provided to them later as part of a support request.  The payer may also add
  a trace which is available also.

## 0.2.1 (January 18, 2018) ##

* Sets required minimum version for ruby to 2.3

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

