# Multithreading

#### Expensive operations within a flow either need to be asynchronous or should run on background threads because overloading the main thread, which handles meta tasks like the event loop, will result in some janky behavior.
#### In Flutter, the entire UI and most of our code run on the root isolate.

- An isolate has its own memory space
- It cannot share mutable values with other isolates
- Any data transmitted between isolates is duplicated
- An isolate runs independently of other isolates
- Regardless of the hierarchy, the parent isolate cannot access the memory of the child isolate.
- The child isolates will terminate if the parent does.

### ReceivePort 
ReceivePort is used by the isolate to receive data. Another instance of this can also be used by the parent isolate to send data to the spawned isolate

### ControlPort
ControlPort is a special port that allows its owner to have capabilities such as pausing or terminating the isolate

### Capability
Capability is object instance used for isolate authentication, 
i.e., whenever we wish to send control port commands like pause or terminate, 
we also need the corresponding instances of Capability that were used when the isolate was created, without which the command would fail


# Compute
- This will execute our code in a different isolate and return the results to our main isolate.

      // JSON decoding is a costly thing its preferable if we did this off the main thread
      Person deserializePerson(String data) {
        Map<String, dynamic> dataMap = jsonDecode(data);
        return Person(dataMap["name"]);
      }

      Future<Person> fetchUser() async {
        String userData = await Api.getUser();
        return await compute(deserializePerson, userData);
      }

This would internally spawn an isolate, run the decoding logic in it, and return the result to our main isolate. 
This is suitable for tasks that are infrequent or one-offs, since we cannot reuse the isolate.

# Spawn
- Isolate.spawn is one of the elementary ways to work with isolates, 
  and it should come as no surprise that the compute method also uses this under the hood.

        Future<Person> fetchUser() async {
          ReceivePort port = ReceivePort();
          String userData = await Api.getUser();
          final isolate = await Isolate.spawn<List<dynamic>>(
            deserializePerson,
            [port.sendPort, userData],
          );
          final person = await port.first;
          isolate.kill(priority: Isolate.immediate);
          return person;
        }

        void deserializePerson(List<dynamic> values) {
          SendPort sendPort = values[0];
          String data = values[1];
          Map<String, dynamic> dataMap = jsonDecode(data);
          sendPort.send(Person(dataMap["name"]));
        }

- The spawn function takes in two parameters:
  1. A callback that is invoked within the new isolate (in our case, deserializePerson)
  2. The parameter that deserializePerson takes

- One of the first things we should do is create an instance of ReceivePort. 
  This allows us to listen to the response of the isolate.

- We combine both the port and the serialized data into a list and send it across. Next, we use sendPort.send to return the value to the main isolate and await the same with port.first. Finally, we kill the isolate to complete the cleanup