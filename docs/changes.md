
# Document Info
This is kinda like a change log. Each change that I make i'm documenting in chronological order. If a statement contradicts something above, consider it a revisison. For example, we changed the onboarding feature described in ### 4 Walkthrough Initial Setup in ### 8 UI revisisons. ### 8 UI revisisons changes superscede ### 4 Walkthrough Initial Setup. 


### 1  First Revisison
(Update 2)
The app needs to function in a drill down type fashion. 
Add a nav bar across the bottom like the old_app
Nav bar sections: 
1. Live View (or some other name that converys the meaning on this screen) - Screen shows all current courts and their activity. Click on a court and it shows the ongoing game, the players on the court and a button to end game. when the end game button is clicked, an end score is requested and the game properly ends and the next game is 
2. On Deck - Shows the next players who are in line. 
3. Facilities (Renamed from Courts (Update 2)) - Shows the court editing screen. Add or remove courts, and activate and deactivate courts. Courts slated for removal or deactivation will not have a game added after the current one (if there is a live game) it will continue until that game's score is entered and then go dormant. can also link to court history somehow. 

(UPDATE 2: We should rename Courts to facilities and using the drill down, be able to maange courts after clicking on which facility they belong to)

4. Players - All players currently in the database. If a player is selected it can link to player history. This screen is the main way to edit the player's info. 
5. Sessions / Historical views - Shows the historical view of the players or courts. Selectable probably by a toggle button at top. If it's players selected, shows a list of players and their amtch history. if it is courts, shows the courts and the history of matches. again, if the person clicks on courts, and then selects a match on that court, and then clicks a player, they will go to the same screen as if a they had clikced on playres and then that player. I didnt explain it well, but you get the idea. 

Sessions - Each use of the app starts with a new session. See the docs about how sessions works. Codebase_Search if you need to. 
We're modeling real life. Currently, I play Monday, Wednesday, and Friday at once place and Tuesday/Thursady at another. I'd like to be able to see my entire play history (and others using this app that I'm adding as players) but I need several different locations as well. So a session takes place at a facility (which has courts) and players are there for a session. but players come and go, so they need to check in to the session. So on the players screen is the list of players, and on the live view, you can add them to an ongoing session. 

I think this is enough for right now, so do the research and see how we can properly transform this app into something closer to what I need.
Take a guess on the UI elements and what will look good, we will revise that after the functionality is good.



### 2 Second Revision

We need to work on the game modes, and we need a game modes link as well.
2 built in modes:
1. King of the Hill - In singles, the loser leaves the court and the next player joins. In doubles, the winning team splits and the losing team leaves the court. The next two players who join are split, one new player joined each exisitng player who are now on opposing teams. 
2. Round Robbin - All players leave the court and new players join. the same for singels and doubles.
This comes to 4 game modes: Singles and Doubles of King of the Hill and Round Robin.

We also need to specify the score that the games are played to. Common scores are 7, 11, 15. but this should be customizeable as well. In pickleball teams need to win by two points. I dont want to get too strict on this, we should accept any score that the players enter after the game is over. 

When a new session is created, each court needs to have a game mode. The system should properly queue players in a massive queue and then slot players as appropriate.
Players should be defaulted to accept all 4 game modes. But each player should be able to deselect a game mode if they dont want to play that. So they would basiclly just tell the person running the app that they dont want to play [insert option here. like "i dont want to play singles"]

When a player is on deck, there should be a skip button. this removes the player from the queue and puts them at the back of the line. We also would need an undo button... so probably app (queue management atleast) wide. So we should be able to undo a game slotting and and a queue skip button. For example if a player is called to a game and it turns out they left. we should be able to undo the match creation and remove that player, and then reslot the game with a new player from the queue. Or if we accidentially press skip on the wrong player, we should be able to undo that. 


### 3 Minor Change Three

On Deck doesnt make sense. This should be labeled as queue. It's the basic view of the line of players and where the system estimates they will be slotted into. We can still maintain the On Deck feature, but maybe it's distinguides by UI styling instead of only showisn that part of the queue. So maybe the system sorts the current matches from oldest (by start time) to newest and then slots the players in that order, expecting the oldest game to finish first. WE need some text to clearly explain this is estimated time and it could change. So if there was a round robin court and a king of the hill court, maybe the round robin game is the oldest and the system preslots people on deck for the round robin match, but then the king of the hill ends first. the system would be wrong... so maybe we just dont do the on deck thing and keep it to a simple queue. The queue can show the live matches and when they started. But we arent setting any expectations of when the games will end. This is probabl cleaner. We can keep the skip functionality available, and before a match is slotted we can add a confirmeation that the players are ready before it's slotted and goes. If a player is not ready at the start time, they can be hard skipped or soft skipped. soft skipped will keep them at the front of the line, but hard skip puts them at the back. We probably need a better terminology for this. 


### 4 Walkthrough Initial Setup

If there's no live view, we need to walk the user through getting started. so we need a series of screens to do the initial config:
Step 1: Create a facility
Step 2: Add courts
Step 3: Create a session - Select courts and game modes for those courts
Step 4: Create at least 2 players
Step 5: Add Players to the session
Step 6: Start the session queue

### 5 Localization

From the very start, we need to think about how to properly translate the app. 
We need to add a App Settings somewhere. (This is also where we can add some paid features later) But the first thing we need to do is to add the ability to change the app language. I think since we are early and planning for this, we should try to limit the words we use on the app as well, if things are able to be conveyed by a icon or photo, we should utilize that. That can help reduce the amount of translating we will do. What are the best practices for localization in a flutter app? 
At minimum, English, Spanish, Chinese, Portuguese, French, Hindi, Malay, Thai, Tagalog/Filipino, Japenese, Vietnamese, Korea, Italian, German, Arabic...

Please add to this document below when we agree on the process:


Localization Plan:

1. **Navigation Structure:**
   - Bottom Nav (5 tabs): Game functionality (Live View, Queue, Facilities, Players, Sessions)
   - Top Hamburger Menu: App settings and configuration

2. **App Settings Screen:**
   - Accessible via hamburger menu (☰) in app bar
   - Contains language selector dropdown
   - Future home for paid features and other settings

3. **Language Support:**
   - Support all 15+ languages from start: English, Spanish, Chinese, Portuguese, French, Hindi, Malay, Thai, Tagalog/Filipino, Japanese, Vietnamese, Korean, Italian, German, Arabic
   - Use flutter_localizations package with ARB files
   - Auto-detect device language with manual override option

4. **Implementation:**
   - Icon-first design to minimize translation work
   - Use universal symbols where possible
   - Only translate essential text (labels, buttons, error messages)
   - Set up localization framework for all languages initially

### 6 Localization Follow Up

Lets set up the comprehensive languages initially. 
We are not implemting paid features right now, but we will in the future. so we should create a dedicated spot for app settings. I dont know if it makes sense to do that on the bottom bar, or if tmakes senst to put some of the features and functionality in another menu, like a handburger menu at the top. like the bottom should be all game settings and the top hamburger menu is all config/settings menu


### 7 Debugging Walkthrough

The walkthrough doesnt work. It accepts the faility and then the success button covers up the next button and the navigation. The success banner should be across the top. probably all messags should be on the top. The app does not progress through the walkthrough and it returns to a create your first facility. This clearly shows we need testing for this walkthrough thing. 


### 8 UI revisisons

This UI is really weird. the first time I clicked on continue nothing happened. I went back and clicked continue again and this is just weird. Lets make it a bit cleaner. We're in this Getting started page... ofcourse the courts are assinged to teh ONLY  facility we have created. why do we need to select a facility?

Maybe we need to make this a bit more intuitive. I've seen walk throughs where the unfilled sections are on the bottom and the fille sections are sumamrize at the top. almost like we're scrolling down a page when we click continue. so we can display relevent data on a line squished above acordian style. 


"You're describing a "sticky header" or "fixed header" pattern, often combined with a "progressive disclosure" or "accordion-style" interface.
More specifically, this sounds like:

Sticky/Fixed Header with Summary - The completed sections get condensed into a compact summary bar that stays pinned at the top as you scroll
Progressive Form Pattern - Where completed steps are collapsed/minimized and the current step is expanded below
"Breadcrumb with Preview" - Similar to breadcrumbs but showing actual data from completed sections
"Collapsible Sections with Sticky Summary" - Each section can collapse to show just key info in a thin bar

This pattern is commonly seen in:

Multi-step checkout flows (showing cart summary at top)
Survey/form builders
Onboarding wizards
Configuration interfaces

The key UX benefit is that users can see their progress and previously entered data at a glance while focusing on the current step. It's like having a "receipt" of your work so far that follows you down the page.
Some designers also call this a "drawer pattern" when sections slide up/down, or a "progressive summary pattern" when it specifically focuses on data collection workflows."



So we would see the 6 steps above at the start, and then as we progress, they are completed and it says something like "Test Facility 1" (or what ever the facility name i) and then "# courts added" and then Session started @ <local time>, and then

actually that order doesnt make sense. we need to add the players and then start the session. thats a major problem. we shoudl error out if a session starts with no players. the session starting should also start the queue. 

this is a major locaial problem I created. help me fix it and redesign the ui

you might be tempted to cover the accordian elements at the top with the success message, but that would be incorrect. the succecss message should wlasy be on the top. we should allow it to cover the app header, which should read Pickleizer

and then the accordian eleemnts below that.



### 9 Walk Through Revisisons - Again

Ok, so this walkthrough should be used when creating a session, not just the first time an app is launched. We need to properly code each ui element to select. but courts are locked to a facility. So if facilities exist, we should select from a drop down or create a new one. If a new facility is created, we need to add courts. if the facility already exists, we should review the courts. game modes should not intrinsicly be linked to courts, we can show the last game mode used on that court, but the user should be able to change the game mode from a drop down. Even mid session, sometimes things change. 
Players are universal, sometimes players play at the same spots on different days. 
Do you know what I mean by these changes? can you reason the implicatinos of this new direction?

Also it looks like the other change of having players created before a session was not implemented yet. please review the previous changes in this documnet. 



