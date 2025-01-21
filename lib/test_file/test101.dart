// // Assuming Element is your data model class
// import 'dart:math';

// class Element {
//   final String id;
//   // Add other properties as needed
  
//   Element({required this.id});
// }

// List<Element> getRandomElements(int numberOfElements, int numberOfQuestions, List<Element> elementData) {
//   final List<Element> elementsArray = [];
//   final List<String> elementIdArray = [];
//   final int numberOfElementsNeeded = numberOfElements * numberOfQuestions;
  
//   // Create an instance of Random
//   final random = Random();
  
//   int i = 0;
//   while (i < numberOfElementsNeeded) {
//     // Generate random ID between 0 and 93 (inclusive)
//     final randomElementId = random.nextInt(94);
    
//     // Find element with matching ID
//     for (var element in elementData) {
//       if (int.parse(element.id) == randomElementId) {
//         if (!elementIdArray.contains(element.id)) {
//           elementsArray.add(element);
//           elementIdArray.add(element.id);
//           i++;
//         }
//         break; // Exit the loop once we find a match
//       }
//     }
//   }
  
//   return elementsArray;
// }