/// API keys
const String googleMapApiKey = 'AIzaSyCWeQpEV267p7Gx8PPDeJHyqHo87SkVw50';
const String twitter_Api = '3TbAxxUlaM5YH0t7YG8yv9EKD';
const String twitter_Secret = 'hP8D3IJBmXKzIaUxxzR20444U620H2t9ihcyq0dhNOBblocvak';
const String facebook_Secret = '471dab6f72e5687a9e593f38faae8d67';

/// Store keys
const String isFirstLogin = 'isFirstLogin';
const String accessToken = 'AccessToken';
const String firebaseToken = 'Firebasetoken';

/// Mime Params
const List<String> supportedMediaTypes = ['jpg', 'png', 'jpeg', 'avi', 'mp4', 'mov'];
const List<String> videoMimeTypes = ['video/avi', 'video/mp4', 'video/mov'];
const List<String> imageMimeTypes = ['image/jpg', 'image/png', 'image/jpeg'];

/// UI texts
const String appName = 'Overheard';
const String emailPlaceholder = 'Email';
const String usernamePlaceholder = 'User name';
const String passwordPlaceholder = 'Password';
const String okButtonText = 'Ok';
const String emailEmptyErrorText = 'Email is required';
const String invalidEmailErrorText = 'Email is Invalid';
const String usernameEmptyErrorText = 'Username is required';
const String passwordEmptyErrorText = 'Password is required';
const String passwordMismatchErrorText = 'Confirm password';
const String signUpSuccessText = 'SignUp Success';
const String signUpFailedText = 'SignUp Failed';
const String signInFailedText = 'SignIn Failed';
const String phonePlaceholder = 'Phone';
const String bioPlaceholder = 'Bio';
const String confirmPasswordPlaceholder = 'Confirm Password';
const String forgotYourPassword = 'Forgot your password?';
const String signInText = 'Sign in';
const String signInWithFB = 'Sign in with Facebook';
const String signInWithTwitter = 'Sign in with Twitter';
const String noAccount = "Don't have an account?";
const String signUpText = 'Sign Up';
const String signUpWithFB = 'Sign up with Facebook';
const String signUpWithTwitter = 'Sign up with Twitter';
const String haveAccount = 'Already have an account?';
const String termsOfUse = 'Terms of Use';
const String privacyPolicy = 'Privacy Policy';
const String acceptTermsAlertTitle = 'Accept Terms';
const String acceptTermsAlertContent = 'I agree to ' + appName + ' App privacy policy and terms of service';
const String cancelButtonText = 'Cancel';
const String acceptTermsAgreeButtonText = 'I Agree';
const String confirmationText = 'Confirmation';
const String authBackAlertContent = 'Do you want really exit?';
const String profileSourceFacebook = 'Facebook';
const String profileSourceTwitter = 'Twitter';
const String profileSourceApple = 'Apple';

const String resendVerificationAppBarTitle = 'Resend verification';
const String resendText = 'Resend';

const String resetPasswordAppBarTitle = 'Restore Password';
const String restorePasswordText = 'Restore';

const String newPasswordAppBarTitle = 'New Password';
const String resetPasswordText = 'Reset';

const String termsOfUseContent = "1. Terms\nBy accessing the website at http://overheard.net, you are agreeing to be bound by these terms of service, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. If you do not agree with any of these terms, you are prohibited from using or accessing this site. The materials contained in this website are protected by applicable copyright and trademark law.\n\n2. Use License\nPermission is granted to temporarily download one copy of the materials (information or software) on Overheard, LLC\'s website for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:\nmodify or copy the materials;\nuse the materials for any commercial purpose, or for any public display (commercial or non-commercial);\nattempt to decompile or reverse engineer any software contained on Overheard, LLC\'s website;\nremove any copyright or other proprietary notations from the materials; or\ntransfer the materials to another person or \"mirror\" the materials on any other server.\nThis license shall automatically terminate if you violate any of these restrictions and may be terminated by Overheard, LLC at any time. Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials in your possession whether in electronic or printed format.\n3. Disclaimer\nThe materials on Overheard, LLC\'s website are provided on an \'as is\' basis. Overheard, LLC makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.\nFurther, Overheard, LLC does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials on its website or otherwise relating to such materials or on any sites linked to this site.\n4. Limitations\nIn no event shall Overheard, LLC or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on Overheard, LLC\'s website, even if Overheard, LLC or a Overheard, LLC authorized representative has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you.\n\n5. Accuracy of materials\nThe materials appearing on Overheard, LLC\'s website could include technical, typographical, or photographic errors. Overheard, LLC does not warrant that any of the materials on its website are accurate, complete or current. Overheard, LLC may make changes to the materials contained on its website at any time without notice. However Overheard, LLC does not make any commitment to update the materials.\n\n6. Links\nOverheard, LLC has not reviewed all of the sites linked to its website and is not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by Overheard, LLC of the site. Use of any such linked website is at the user\'s own risk.\n\n7. Modifications\nOverheard, LLC may revise these terms of service for its website at any time without notice. By using this website you are agreeing to be bound by the then current version of these terms of service.\n\n8. Governing Law\nThese terms and conditions are governed by and construed in accordance with the laws of Michigan and you irrevocably submit to the exclusive jurisdiction of the courts in that State or location.";
const String privacyPolicyContent = "Your privacy is important to us. It is Overheard, LLC\'s policy to respect your privacy regarding any information we may collect from you across our website, http://overheard.net, and other sites we own and operate.\n\nWe only ask for personal information when we truly need it to provide a service to you. We collect it by fair and lawful means, with your knowledge and consent. We also let you know why we’re collecting it and how it will be used.\n\nWe only retain collected information for as long as necessary to provide you with your requested service. What data we store, we’ll protect within commercially acceptable means to prevent loss and theft, as well as unauthorized access, disclosure, copying, use or modification.\n\nWe don’t share any personally identifying information publicly or with third-parties, except when required to by law.\n\nOur website may link to external sites that are not operated by us. Please be aware that we have no control over the content and practices of these sites, and cannot accept responsibility or liability for their respective privacy policies.\n\nYou are free to refuse our request for your personal information, with the understanding that we may be unable to provide you with some of your desired services.\n\nYour continued use of our website will be regarded as acceptance of our practices around privacy and personal information. If you have any questions about how we handle user data and personal information, feel free to contact us.\n\nThis policy is effective as of 21 November 2020.";
const String aboutUsContent = 'Overheard, LLC in a mobile application. It’s community based news and gossip by the people who are the news and gossip. Members of each community post news or gossip within respective geographical community based news feeds. What’s unique about Overheard is that it delivers real-time reporting by the people who are directly involved, and incentivizes those who report engaging and relevant content.';
const String faqContent = 'Question One?\nFar far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts.\n\nQuestion Two?\nSeperated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean.\n\nQuestion Three?\nFar far away, behind the word mountains, far from the countries Vokakia and Consonantia, there live the blind texts.\n\nQuestion Four?\nSeperated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean.\n\nQuestion Five?\nFar far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts.';


const String completeProfileAppBarTitle = 'Complete My Profile';
const String uploadPhotoText = 'Upload Photo';
const String firstNamePlaceholder = 'First name';
const String lastNamePlaceholder = 'Last name';
const String verifiedReporterRequestText = 'Became a verified ' + appName + ' reporter';
const String profileCompleteText = 'Complete';
const String takePhotoText = 'Take photo';
const String chooseFromLibraryText = 'Choose from Library';

const String cropPhotoAppBarTitle = 'Crop Photo';
const String doneButtonText = 'Done';

const String nearestCommunityAppBarTitle = 'Nearest Communities';
const String confirmButtonText = 'Confirm';
const String submitCommunityButtonText = 'Submit Coummunity';
const String searchPlaceholder = 'Search';
const String skipButtonText = 'Skip';
const String noCommunityFoundText = 'No Community Found';
const String confirmCommunityDialogTitle = 'Allow <<%s>> to access your Location?';
const String confirmCommunityDialogContent = 'A short, complete sentence that takes up the first and the second line.';

const String submitCommunityAppBarTitle = 'Submit Community';
const String communityNamePlaceholder = 'Community name';
const String zipCodePlaceholder = 'Zip-code';
const String submitButtonText = 'Submit';

const String feedBottomButtonText = 'Feed';
const String chatBottomButtonText = 'Chat';
const String createPostBottomButtonText = 'Create Post';
const String notificationsBottomButtonText = 'Notifications';
const String profileBottomButtonText = 'Profile';

const String feedText = 'Feed';
const String postDetailAppBarTitle = 'Post Details';
const String reportText = 'Report';
const String shareText = 'Share';
const String copyLinkText = 'Copy Link';
const String editText = 'Edit';
const String deleteText = 'Delete';
const String voteErrorText = "You can't vote again";
const String commentsText = "Comments";

const String commentPlaceholder = 'Leave Comment ...';
const String reportAppBarTitle = 'Report';
const String sendButtonText = 'Send';
const String reportReasonPlaceholder = 'Reason';
const String reportContentPlaceholder = 'Your Report Text here ...';

const String editPostAppBarTitle = 'Edit Post';
const String saveButtonText = 'Save';
const String postTitlePlaceholder = 'Title';
const String postContentPlaceholder = 'Post Content';
const String postTagPlaceholder = 'Post Tags';
const String postLocationPlaceholder = 'Location';
const String postMediaAddText = 'ADD PHOTO/VIDEO';

const String feedPostText = 'Feed Post';
const String liveStreamPostText = 'Live Stream';

const String createPostAppBarTitle = 'Create Post';
const String finishButtonText = 'Finish';
const String maxImgErrorText = "You can't add photo anymore";
const String locationPickErrorText = "You can't choose this postion";

const String locationPickerAppBarTitle = 'Location';

const String getProfileErrorText = 'Failed to get profile';
const String myEarningsText = 'My Earnings';
const String changeCommunityText = 'Change Community';
const String followersText = 'Followers';
const String followingText = 'Following';
const String settingsText = 'Settings';
const String editProfileText = 'Edit Profile';
const String followButtonText = 'Follow';
const String unfollowButtonText = 'Unfollow';
const String joinButtonText = 'Join';
const String joinedButtonText = 'Joined';
const String joinCommunityText = 'Join Community';

const String advertisePostText = 'Advertise Post';



const String editProfileAppBarTitle = 'Edit Profile';
const String changeProfilePhotoText = 'Change Profile Photo';

const String followerAppBarTitle = 'Follower';
const String communityAppBarTitle = 'Community';

const String privacyText = 'Privacy';
const String changePasswordText = 'Change Password';
const String addEmailText = 'Add Email';
const String blockedUserText = 'Blocked User';
const String myPaymentsText = 'My Payments';
const String notificationText = 'Notification';
const String aboutAppText = 'About App';
const String termsAndConditionsText = 'Terms & Conditions';
const String privacyPolicyText = 'Privacy Policy';
const String aboutUsText = 'About Us';
const String contactUsText = 'Contact Us';
const String faqText = 'FAQ';
const String logoutText = 'Log Out';
const String firstNameEmptyErrorText = 'Firstname is required';
const String lastNameEmptyErrorText = 'Lastname is required';
const String bioEmptyErrorText = 'Bio is required';
const String joinedCommunityEmptyErrorText = 'Please Join to a Community';
const String locationPermissionDeniedErrorText = 'Location Permission Denied';
const String communityConfirmFailedText = 'Community Confirmation Failed';
const String postContentEmptyErrorText = 'Please Add Content';
const String locationEmptyErrorText = 'Please Choose Location';
const String reportReasonEmptyErrorText = 'Please Add Report Reason';
const String reportContentEmptyErrorText = 'Please Add Report Content';
const String feedTitleEmptyErrorText = 'Please Add Feed Title';
const String communityNameEmptyErrorText = 'Please fill Community Name';
const String zipCodeEmptyErrorText = 'Please fill zipcode';

const String deletePostAlertTitle = 'Delete Post?';
const String deletePostAlertContent = 'Please confirm to delete this post.';
const String joinToAnotherCommunityContent = 'Do you want to leave your current community and join new?';
const String noFollowersText = 'No Followers';
const String noFollowingsText = 'No Followings';
const String noBlockedUserText = 'No Blocked Users';
const String blockButtonText = 'Block';
const String unblockButtonText = 'UnBlock';

const String oldPasswordHintText = 'Old Password';
const String newPasswordHintText = 'New Password';
const String passwordChangeFaileText = 'Failed to change password';
const String passwordChangedText = 'You have changed password';

const String noFeedFoundText = 'No Feed Found';
const String noLiveStreamFoundText = 'No Live Stream';
const String imagePickText = 'Image';
const String videoPickText = 'Video';



const String chatText = "Chats";
const String noChatText = "You don't have any Chats yet.";
const String createChatAppBarTitle = "Create New Chat";
const String deleteChatAlertTitle = "Delete Chat";
const String deleteChatAlertContent = "If you tap confirm button all messages and attachments history will be deleted";
const String noMessageText = "No messages";
const String msgTextEmptyErrorText = "Message Text is required";
const String wrong300ErrorText = "Less than 301 characters";
const String chatBlockPlaceholderText = "This Chat has been blocked";
const String copyText = "Copy";
const String copyClipboard = "Copied to Clipboard";
const String photoVideoText = "Photo/Video";

/// API routes
/// Auth Related Urls
// const String BASE_ROUTE = 'https://overheard.net';
// const String BASE_ROUTE = 'http://10.0.2.2:8000';
const String BASE_ROUTE = 'http://192.168.1.3:8000';
const String SOCKET_URL = 'ws://192.168.1.15:6001';
const String SIGNIN_URL = '/api/auth/signin';
const String FIREBASE_SIGNIN_URL = '/api/auth/firebaseSignIn';
const String SIGNUP_URL = '/api/auth/signup';
const String VERIFY_RESEND_URL = '/email/resend?email=';
const String FIREBASE_SIGNUP_URL = '/api/auth/firebaseSignUp';
const String SIGNIN_WITH_TOKEN_URL = '/api/access-token';
const String RESTORE_PASSWORD_URL = '/api/auth/restore_password';
const String RESET_PASSWORD_URL = '/api/auth/reset_password';

/// Profile Related Urls
const String UPDATE_AVATAR_URL = '/api/avatar_upload';
const String COMPLETE_PROFILE_URL = '/api/complete_profile';
const String GET_PROFILE_URL = '/api/get_profile';
const String FETCH_PROFILE_FEED_URL = '/api/get_profile_feeds';
const String FOLLOW_MANAGE_URL = '/api/follow_manage';
const String BLOCK_MANAGE_URL = '/api/block_manage';
const String FETCH_FOLLOWERS_URL = '/api/fetch_followers';
const String FETCH_FOLLOWINGS_URL = '/api/fetch_followings';
const String FETCH_BLOCKED_USERS_URL = '/api/fetch_blocked_users';
const String CHANGE_PASSWORD_URL = '/api/change_password';

/// Community Related Urls
const String FETCH_COMMUNITY_URL = '/api/get_communities';
const String CONFIRM_COMMUNITY_URL = '/api/confirm_community';
const String SUMBIT_COMMUNITY_URL = '/api/submit_community';

/// Feeds Related Urls
const String FETCH_FEED_URL = '/api/get_feeds';
const String GET_LOCATION_URL = '/api/get_location';
const String POST_FEED_CONTENT_URL = '/api/post_feed_content';
const String POST_FEED_ATTACHES_URL = '/api/post_feed_media';
const String GET_FEED_URL = '/api/get_feed';
const String REPORT_FEED_URL = '/api/report_feed';
const String COMMENT_FEED_URL = '/api/comment_feed';
const String COMMENT_VOTE_URL = '/api/comment_vote';
const String FEED_VOTE_URL = '/api/feed_vote';
const String EDIT_FEED_CONTENT_URL = '/api/edit_feed_content';
const String DELETE_FEED_URL = '/api/delete_feed';