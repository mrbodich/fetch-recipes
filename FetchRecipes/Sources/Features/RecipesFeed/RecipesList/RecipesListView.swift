//
//  RecipesListView.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/10/24.
//

import SwiftUI

struct RecipesListView: View {
    @State private var sorting: RecipesListSorting = .nameAscending
    
    @ObservedObject var viewModel: RecipesListVM
    
    var body: some View {
        GeometryReader { _ in
            Group {
                switch viewModel.state {
                case let .loaded(recipes) where !recipes.isEmpty:
                    let recipes = sortedRecipes(recipes)
                    let ids = recipes.map(\.id)
                    ScrollViewReader { proxy in
                        ListScrollView {
                            recipesView(recipes)
                        }
                        .animation(.easeInOut(duration: 0.3), value: ids)
                        /// Scroll to the top on sorting change
                        .onChange(of: ids) { newValue in
                            DispatchQueue.main.async {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    proxy.scrollTo(newValue.first)
                                }
                            }
                            
                        }
                    }
                case .loaded:
                    warningView(Ln.recipesEmpty, color: .blue)
                case .none:
                    Text(Ln.recipesLoad)
                        .padding(.horizontal, Spacing.s2)
                        .padding(.vertical, Spacing.s1)
                        .foregroundStyle(Color.blue)
                        .buttonWrapped {
                            Task {
                                await viewModel.refresh()
                            }
                        }
                        .opacity(viewModel.isRefreshing ? 0 : 1)
                        .overlay {
                            if viewModel.isRefreshing {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            }
                        }
                        .animation(.easeInOut(duration: 0.2), value: viewModel.isRefreshing)
                case .error:
                    warningView(Ln.recipesError, color: .red)
                }
            }
            .transition(.opacity.animation(.easeInOut(duration: 0.3)))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .refreshable {
            if !viewModel.isRefreshing {
                await viewModel.refresh()
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                let isDisabled = switch viewModel.state {
                case let .loaded(recipes)
                    where !recipes.isEmpty: false
                default: true
                }
                sortingView
                    .disabled(isDisabled)
                    .animation(
                        .easeInOut(duration: 0.3),
                        value: isDisabled
                    )
            }
        }
    }
    
    @ViewBuilder
    private func recipesView(_ recipes: [Recipe]) -> some View {
        ForEach(recipes) {
            RecipeFeedRowView(recipe: $0)
                .padding(.bottom, Spacing.s2)
                .id($0.id)
        }
    }
    
    private var sortingView: some View {
        Menu {
            Picker(selection: $sorting) {
                Text(Ln.sortByName)
                    .tag(RecipesListSorting.nameAscending)
                
                Text(Ln.sortByCuisineName)
                    .tag(RecipesListSorting.cuisineAscending)
            } label: {
                Image(systemName: "arrow.up.arrow.down.square.fill")
                    .contentShape(Rectangle())
            }
        } label: {
            HStack(spacing: Spacing.half) {
                Image(systemName: "arrow.up.arrow.down.square.fill")
                    .contentShape(Rectangle())
                Text(Ln.sort)
            }
        }
    }
    
    private func sortedRecipes(_ recipes: [Recipe]) -> [Recipe] {
        recipes.sorted {
            switch sorting {
            case .nameAscending:
                $0.name.localizedCompare($1.name) == .orderedAscending
            case .cuisineAscending:
                $0.cuisine.localizedCompare($1.cuisine) == .orderedAscending
            }
        }
    }
    
    private func warningView(_ message: String, color: Color) -> some View {
        VStack(spacing: Spacing.s2) {
            Text(message)
                .font(.title3)
            
            Text(Ln.reload)
                .padding(.horizontal, Spacing.s2)
                .padding(.vertical, Spacing.s1)
                .border(color, width: 1)
                .buttonWrapped {
                    Task {
                        await viewModel.refresh()
                    }
                }
            
        }
    }
}

#if DEBUG
#Preview {
    let viewModel = ScreenFabricMock(delay: 0.5)
        .recipesListVM()
    
//    let viewModel = RecipesListVM {
//        try await Task.sleep(for: .seconds(0))
//        throw NSError(domain: "", code: 0)
//    }
    
//    let viewModel = RecipesListVM {
//        try await Task.sleep(for: .seconds(0))
//        return []
//    }
    
    NavigationView {
        RecipesListView(
            viewModel: viewModel
        )
    }
    .mockImageFetcher()
    .task {
        await viewModel.refresh()
    }
}
#endif
