*Domains
noCheckNoGrowFillFrom: anArray
	"Add the elements of anArray except nils and flag to me assuming that I don't contain any of them, they are unique and I have more free space than they require."

	<nonDomainMediated>
	tally := 0.
	1 to: anArray size do: [ :index |
		(anArray at: index) ifNotNil: [ :object |
			object == flag ifFalse: [
				array
					at: (self scanForEmptySlotFor: object enclosedElement)
					put: object.
				tally := tally + 1 ] ] ]