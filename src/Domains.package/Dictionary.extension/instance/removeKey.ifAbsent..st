*Domains
removeKey: key ifAbsent: aBlock
	"Remove key (and its associated value) from the receiver. If key is not in
	the receiver, answer the result of evaluating aBlock. Otherwise, answer
	the value externally named by key."

	| index assoc |
	index := self findElementOrNil: key.
	assoc := (array at: index) ifNil: [ ^ aBlock value ].
	tally := tally - 1.
	array at: index put: nil.
	self fixCollisionsFrom: index.
	^ assoc value