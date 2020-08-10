# KoshelekDogs

Test task from the company "Koshelek.ru"

Using the API from https://dog.ceo/dog-api/documentation/breed
And the design pattern does the following:

1. On the first tab, get a list of all dog breeds. (Heading above: Breeds) List in the table. If the breed has sub-breeds, display the number of sub-breeds as a number. Clicking on a cell to open a new screen:

- if there are no sub-breeds, then a screen should open on which all photos of this breed in a horizontal collection should be displayed, photos in full screen size, there should also be a button below to like the photo. There is also a button on the top to share this photo with friends. (Heading above: Name of the selected breed)

- if there are sub-breeds, then open the same list only with sub-breeds. When you click on a cell, a screen opens with photos of a specific sub-breed and a button to like from below (Heading above: Name of the selected breed)

2. On the second tab, display the list of breeds you liked (breeds and sub-breeds in the list at the same level, that is, all breeds and sub-breeds are immediately displayed) and the number of photos you liked for a particular breed as a number. When you click on a cell, a screen opens with photos of a specific sub-breed and a button to like from below and a button from above to share with friends. You can unlay the photo. Which should remove it from the list after leaving the screen.

The likes state should persist after exiting the app. Add a loader while waiting for a response from the server, and in case of an error from the server, display an alert with an explanation. We use the attached template.

------------------------------------------------------------------------------

It took me about 8-10 hours to create and debug the application. The desire to do any test tasks begins to fall strongly ... ) The employer estimated this task at 3 hours, and I, by my naivety, believed him) Now I will get rid of the debts accumulated during this time ... )

<img src="/source/firstScreen.png" alt="first screen"/> <img src="/source/secondScreen.png" alt="second screen"/>
