//
//  ContentView.swift
//  Todo
//
//  Created by luis armendariz on 7/24/23.
//

import SwiftUI
import CoreData

struct TodoRowView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var todo: Todo
   
    
    var body: some View{
        HStack{
            TextField("Todo", text: $todo.text)
                .onChange(of: todo.text){newValue in
                    try? viewContext.save()
                    
                }
            Spacer()
            Image(systemName: todo.isDone ? "checkmark.circle" : "circle")
                .onTapGesture {
                    todo.isDone.toggle()
                    try? viewContext.save()
                }
        }
    }
}


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Todo.timestamp, ascending: true)],
        animation: .default)
    private var todos: FetchedResults<Todo>

    var body: some View {
        NavigationStack {
            List {
                ForEach(todos) { todo in
                   TodoRowView(todo: todo)
                }
                .onDelete(perform: deleteTodo)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addTodo) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Todos✅")
        }
    }

    private func addTodo() {
        withAnimation {
            let todo = Todo(context: viewContext)
            todo.timestamp = Date()
            todo.text = ""
            todo.isDone = false
            try? viewContext.save()
            
        }
    }

    private func deleteTodo(offsets: IndexSet) {
        withAnimation {
            offsets.map { todos[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
