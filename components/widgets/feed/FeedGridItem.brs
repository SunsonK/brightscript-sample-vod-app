sub init()
    m.FeedGridItemPoster = m.top.findNode("feedGridItemPoster")
    m.FeedGridItemAgeRating = m.top.findNode("feedGridItemAgeRating")
    m.FeedGridItemTitle = m.top.findNode("feedGridItemTitle")
    m.FeedGridItemSummary = m.top.findNode("feedGridItemSummary")
end sub

sub onContentChange(message as Object)
    content = message.getData()

    m.FeedGridItemPoster.uri = content.imageUri
    setupFeedGridItemAgeRating(content.ageRating)
    m.FeedGridItemTitle.text = content.title
    m.FeedGridItemSummary.text = content.summary
end sub

sub setupFeedGridItemAgeRating(ageRating as Integer)
    m.FeedGridItemAgeRating.properties = {
        width: 36,
        height: 36,
        color: "#B00020",
        opacity: 0.8,
        labelColor: "#ECECEC",
        labelText: Str(ageRating),
        labelSize: 18
    }
end sub

