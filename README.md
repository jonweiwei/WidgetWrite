# WidgetWrite
#### A note-taking app that allows users to display their most recently opened note as a widget.

## The App
The app displays all notes in a simple list with their titles and last edited timestamps. By default, notes are sorted by newest but the button on the top right can be used to toggle the sort method from newest to oldest and vice versa. Users can delete notes by swiping left on a specific note to reveal the delete button.

When creating a new note, a sheet will pop up which allows users to enter in the title of the new note and save it.

<img src="/WidgetWrite/Assets.xcassets/contentviewscreenshot.imageset/contentviewscreenshot.png?raw=true" width="250"> &emsp; <img src="/WidgetWrite/Assets.xcassets/deletenotescreenshot.imageset/deletenotescreenshot.png?raw=true" width="250"> &emsp; <img src="/WidgetWrite/Assets.xcassets/newnotescreenshot.imageset/newnotescreenshot.png?raw=true" width="250">

The note view displays the note canvas, along with the title of the note at the top of the screen and the PencilKit tool picker at the bottom. Changes to the note are automatically saved and users can easily navigate back to the note list using the button on the top left.

<img src="/WidgetWrite/Assets.xcassets/canvasviewscreenshot.imageset/canvasviewscreenshot.png?raw=true" width="300">

## The Widget
The app will share the data of the most recently opened note with the widget extension. Users are able to display the note on a widget of any size (including extra large for iPad).

<img src="/WidgetWrite/Assets.xcassets/widgetscreenshot.imageset/widgetscreenshot.png?raw=true" width="300">
