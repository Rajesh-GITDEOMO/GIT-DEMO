//test class
//test force.com class
//test Subhadeep 6:58 pm
//test Chirayu 01:11 Am
//test rajesh 1234
//Conflict test Rajesh 5:21 PM
//hello
//hello1
//test Subhadeep 0221
//test change 5:51 PM move to sub branch
//test brach rajesh
// test 22 Feb 2016 5:40 PM
// test 22 Feb 2016 5:46 PM
//test brach Chriayu 16/2 05:18 PM

//test jenkin  automation123
//test rajesh commit 7:07 PM 22 feb 2016

//test Sub-branch chirayu 22/feb/2016 06:58 PM

 
//tesr rajesh 8:13 PM

//test Chirayu 08:06 PM
//test Raj  Jenkins 10:20 AM

public class ChatterGalleryPageController{
    public transient List<ChatterImage> images;

    //HEELO BOSS1458

    //HEELO BOSS1234325525

    public ChatterGalleryPageController(){
        instantiateImages();
        ConnectApi.FeedItemPage feedPage = getFirstFeedItemPageOfInternalPosts();
        generateImages(feedPage);
    }

    private void instantiateImages(){
        images = new List<ChatterImage>();
    }

    private ConnectApi.FeedItemPage getFirstFeedItemPageOfInternalPosts(){
        return ConnectApi.ChatterFeeds.getFeedItemsFromFeed('internal', ConnectApi.FeedType.Files, UserInfo.getUserId());
    }

    private void generateImages(ConnectApi.FeedItemPage feedPage){
        for(ConnectApi.FeedItem item:feedPage.items){
            if(doesFeedItemContainContentAttachment(item)){
                ifAttachmentIsImageAddToList(item);
            }
        }
    }

    private Boolean doesFeedItemContainContentAttachment(ConnectApi.FeedItem item){
        return item.attachment != null && item.attachment instanceOf ConnectApi.ContentAttachment;
    }

    private void ifAttachmentIsImageAddToList(ConnectApi.FeedItem item){
        ConnectApi.ContentAttachment image = (ConnectApi.ContentAttachment)item.attachment;
        if(image.mimeType.contains('image')){
            images.add(new ChatterImage(item, image));
        }
    }

    public List<ChatterImage> getImages(){
        return images;
    }

    @RemoteAction
    public static List<ConnectApi.ChatterLike> getLikesForImage(String feedItemId){
        ConnectApi.ChatterLikePage likePage = ConnectApi.ChatterFeeds.getLikesForFeedItem('internal', feedItemId);
        return likePage.likes;
    }

    public class ChatterImage{
        public transient ConnectApi.FeedItem item;
        public transient ConnectApi.ContentAttachment image;
        public ChatterImage(ConnectApi.FeedItem item, ConnectApi.ContentAttachment image){
            this.item = item;
            this.image = image;
        }

        public ConnectApi.FeedItem getItem(){
            return item;
        }

        public ConnectApi.ContentAttachment getImage(){
            return image;
        }
    }
}