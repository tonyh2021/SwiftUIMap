//
//  LocationsView.swift
//  SwiftUIMap
//
//  Created by Tony on 2023-03-25.
//

import SwiftUI
import MapKit

struct LocationsView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    
    private let maxWidthForIPad: CGFloat = 700

    var body: some View {
        ZStack {
            mapLayer
            
            VStack(spacing: 0) {
                headerWrapper
                    .padding()
                    .frame(maxWidth: maxWidthForIPad)
                Spacer()
                preview
            }
        }
        .sheet(item: $vm.sheetLocation, content: { location in
            LocationDetailView(location: location) {
                vm.sheetLocation = nil
            }
        })
    }
}

extension LocationsView {
    
    private var mapLayer: some View {
        Map(coordinateRegion: $vm.mapRegion,
            annotationItems: vm.locations,
            annotationContent: { location in
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnnotationView()
                    .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
                    .shadow(radius: 10)
                    .onTapGesture {
                        vm.showNextLocation(location: location)
                    }
            }
        })
        .ignoresSafeArea()
    }
    
    private var header: some View {
        VStack {
            Button {
                vm.toggleLocationList()
            } label: {
                Text(vm.mapLocation.name + ", "
                     + vm.mapLocation.cityName)
                .font(.title2)
                .fontWeight(.black)
                .foregroundColor(.primary)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .animation(.none, value: vm.mapLocation)
                .overlay(
                    Image(systemName: "arrow.down")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding()
                        .rotationEffect(Angle(degrees: vm.showLocationList ? 180 : 0))
                    , alignment: .leading
                )
            }
            
            if vm.showLocationList {
                LocationListView()
            }
        }
    }
    
    private var headerWrapper: some View {
        ZStack {
            if #available(iOS 15.0, *) {
                header
                    .background(
                        .thickMaterial
                    )
            } else {
                // Fallback on earlier versions
                header
                    .background(
                        Color.white.opacity(0.8)
                    )
            }
        }
        .cornerRadius(10)
        .shadow(
            color: Color.black.opacity(0.3),
            radius: 20,
            x: 0,
            y: 15
        )
    }
    
    private var preview: some View {
        ZStack {
            ForEach(vm.locations) { location in
                if vm.mapLocation == location {
                    LocationPreviewView(
                        location: location,
                        onNextPressed: vm.nextButtonPressed, onLearnMorePressed: {
                            vm.sheetLocation = location
                        })
                    .shadow(color: Color.black.opacity(0.3), radius: 20)
                    .padding()
                    .frame(maxWidth: maxWidthForIPad)
                    .frame(maxWidth: .infinity)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)))
                }
            }
        }
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView()
            .environmentObject(LocationsViewModel())
    }
}
