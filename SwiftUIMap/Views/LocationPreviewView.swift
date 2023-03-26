//
//  LocationPreviewView.swift
//  SwiftUIMap
//
//  Created by Tony on 2023-03-25.
//

import SwiftUI

struct LocationPreviewView: View {
    
    let location: Location

    let onNextPressed: (() ->  Void)
    let onLearnMorePressed: (() ->  Void)
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                imageSection
                titleSection
            }

            VStack(spacing: 8) {
                learnMoreButton
                nextButton
            }
        }
        .padding(20)
        .background(
            roundedRectangle
        )
        .cornerRadius(10)
    }
}

extension LocationPreviewView {
    
    private var roundedRectangle: some View {
        let base = ZStack {
            Color.clear
        }
        
        var bluredView: some View {
            if #available(iOS 15.0, *) {
                return base
                    .background(.ultraThinMaterial)
            } else {
                // Fallback on earlier versions
                return base
                    .background(Blur(style: .systemUltraThinMaterial))
            }
        }
        
        return bluredView
            .cornerRadius(10)
            .offset(y: 65)
    }
    
    private var imageSection: some View {
        ZStack {
            if let url = location.imageNames.first {
                Image(url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            }
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(location.name)
                .font(.title2)
                .fontWeight(.bold)
            Text(location.cityName)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func buildText(_ text: String) -> some View {
        return Text(text)
            .font(.headline)
            .frame(width: 125, height: 35)
    }
    
    private var learnMoreButton: some View {
        let textView = buildText("Learn more")
        if #available(iOS 15.0, *) {
            return Button {
                onLearnMorePressed()
            } label: {
                textView
            }
            .buttonStyle(.borderedProminent)
        } else {
            // Fallback on earlier versions
            return Button {
                onLearnMorePressed()
            } label: {
                textView
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
            }
            .background(Color.accentColor)
            .cornerRadius(8)
            .shadow(color: Color.primary, radius: 0.5, y: 0.5)
        }
    }
    
    private var nextButton: some View {
        let textView = buildText("Next")
    
        if #available(iOS 15.0, *) {
            return Button {
                onNextPressed()
            } label: {
                textView
            }
            .buttonStyle(.bordered)
        } else {
            // Fallback on earlier versions
            return Button {
                onNextPressed()
            } label: {
                textView
                    .foregroundColor(Color.accentColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
    }
}

struct LocationPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            LocationPreviewView(location: LocationsDataService.locations.first!) {
                print("next")
            } onLearnMorePressed: {
                print("learn more")
            }

        }
    }
}
