//
//  ContentView.swift
//  GetInfoFromGitHubAPI
//
//  Created by Артём on 20.04.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var user: GitHubUser?
    
    var body: some View {
        VStack {
            Text("Info from GitHub")
                .font(.system(size: 32, weight: .bold, design: .monospaced))

            Spacer()
            
            AsyncImage(url: URL(string: user?.avatar_url ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.circle)
            } placeholder: {
                Circle()
                    .foregroundStyle(.secondary)
                    .border(.gray)
            }
            .frame(width: 140, height: 140)
            
            Text(user?.login ?? "Username")
                .bold()
                .font(.title)
            
            Text(user?.bio ?? "Here is some biography about the user")
                .padding()
                .font(.system(size: 26, weight: .medium, design: .serif))
            
            Spacer()
        }
        .padding()
        .task {
            do {
                user = try await getData()
            } catch ErrorType.wrongData {
                print("wrongData")
            } catch ErrorType.wrongResponse {
                print("wrongResponse")
            } catch ErrorType.wrongURL {
                print("wrongURL")
            } catch {
                print("unexpected error")
            }
        }
    }
    
    func getData() async throws -> GitHubUser {
        let link = "https://api.github.com/users/t3mv-l"
        
        guard let url = URL(string: link) else {
            throw ErrorType.wrongURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ErrorType.wrongResponse
        }
        
        guard let userData = try? JSONDecoder().decode(GitHubUser.self, from: data) else {
            throw ErrorType.wrongData
        }
        
        return userData
    }
}

struct GitHubUser: Codable {
    let login: String
    let avatar_url: String
    let bio: String
}

enum ErrorType: Error {
    case wrongURL
    case wrongResponse
    case wrongData
}

#Preview {
    ContentView()
}
