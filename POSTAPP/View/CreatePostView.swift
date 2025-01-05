//
//  CreatePostView.swift
//  POSTAPP
//
//  Created by Jorge Jair Ramirez Gaston Zuloeta on 5/01/25.
//

import SwiftUI

struct CreatePostView: View {
    
    // MARK: - PROPETIES
    @StateObject private var viewModel = CreatePostViewModel()
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State private var animateBackground = false
    @State private var showContent = false
    
    // Custom colors
    private let gradientColors = [
        Color(hex: "FF6B6B"),
        Color(hex: "4ECDC4"),
        Color(hex: "45B7D1")
    ]
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(colors: gradientColors, startPoint: animateBackground ? .topLeading : .bottomTrailing,
                         endPoint: animateBackground ? .bottomTrailing : .topLeading)
                .opacity(0.15)
                .blur(radius: 50)
                .scaleEffect(1.5)
                .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: animateBackground)
            
            ScrollView {
                VStack(spacing: 25) {
                    // Title Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Título")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        TextField("¿Qué quieres compartir hoy?", text: $viewModel.title)
                            .textFieldStyle(.plain)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                    }
                    .offset(y: showContent ? 0 : 50)
                    .opacity(showContent ? 1 : 0)
                    
                    // Content Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Contenido")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        TextEditor(text: $viewModel.body)
                            .frame(minHeight: 200)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                    }
                    .offset(y: showContent ? 0 : 50)
                    .opacity(showContent ? 1 : 0)
                    
                    // Submit Button
                    Button(action: {
                        Task { @MainActor in
                            // Iniciamos la animación
                            withAnimation(.spring()) {
                                viewModel.isLoading = true
                            }
                            // Ejecutamos la operación asíncrona
                            await viewModel.createPost()
                            await viewModel.fetchRandomTitle()
                            // Finalizamos la animación si es necesario
                            withAnimation(.spring()) {
                                viewModel.isLoading = false
                            }
                        }
                    }) {
                        HStack {
                            Text("Publicar")
                                .fontWeight(.bold)
                            
                            if viewModel.isLoading {
                                Spacer()
                                ProgressView()
                                    .tint(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "FF6B6B"), Color(hex: "FF8E8E")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color(hex: "FF6B6B").opacity(0.3), radius: 10, x: 0, y: 5)
                        )
                        .foregroundColor(.white)
                    }
                    .disabled(viewModel.title.isEmpty || viewModel.body.isEmpty || viewModel.isLoading)
                    .offset(y: showContent ? 0 : 50)
                    .opacity(showContent ? 1 : 0)
                    
                    Text(viewModel.randomTitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 10)
                        .multilineTextAlignment(.center)
                        .offset(y: showContent ? 0 : 50)
                        .opacity(showContent ? 1 : 0)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Nueva Publicación")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") { viewModel.error = nil }
        } message: {
            Text(viewModel.error ?? "")
        }
        .alert("¡Publicación Creada!", isPresented: .constant(viewModel.successMessage != nil)) {
            Button("OK") {
                viewModel.successMessage = nil
                dismiss()
            }
        } message: {
            Text(viewModel.successMessage ?? "")
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showContent = true
            }
            animateBackground = true
        }
    }
}

