import SwiftUI

/// Equivalent of Kotlin's ReservaDialog composable.
struct ReservaDialogView: View {

    let complex: ComplexDto
    var onConfirm: (Reserva) -> Void
    var onDismiss: () -> Void

    @State private var selectedDate: Date? = nil
    @State private var hora        = "08:00"
    @State private var duracion    = 1
    @State private var showDatePicker = false

    private var precioTotal: Double { complex.minPrice * Double(duracion) }

    private var fechaString: String {
        guard let d = selectedDate else { return "" }
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.string(from: d)
    }

    private var canConfirm: Bool { selectedDate != nil && !hora.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Date selector button
                    Button { showDatePicker = true } label: {
                        HStack {
                            Image(systemName: "calendar").font(.system(size: 16))
                            Text(selectedDate == nil ? "Seleccionar fecha" : fechaString)
                                .fontWeight(selectedDate == nil ? .regular : .semibold)
                            Spacer()
                        }
                        .foregroundColor(.hGreenAccent)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.hGreenAccent, lineWidth: 1.5)
                        )
                    }

                    // Hora
                    TextField("Hora (ej: 10:00)", text: $hora)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numbersAndPunctuation)

                    // Duración chips
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Duración: \(duracion) hora\(duracion > 1 ? "s" : "")")
                            .font(.system(size: 15, weight: .medium))
                        HStack(spacing: 8) {
                            ForEach([1, 2, 3], id: \.self) { h in
                                Button("\(h)h") { duracion = h }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(duracion == h ? Color.hGreenAccent : Color.clear)
                                    .foregroundColor(duracion == h ? .white : .hGreenAccent)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.hGreenAccent, lineWidth: 1)
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }

                    // Total price
                    Text("Total: $\(Int(precioTotal / 1000))k")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(.hGreenAccent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
            .navigationTitle("Reservar en \(complex.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { onDismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirmar") {
                        onConfirm(
                            Reserva(
                                complexId:     complex.complexId,
                                complexName:   complex.name,
                                address:       complex.address,
                                city:          complex.city,
                                fecha:         fechaString,
                                hora:          hora.trimmingCharacters(in: .whitespaces),
                                duracionHoras: duracion,
                                precioTotal:   precioTotal
                            )
                        )
                    }
                    .disabled(!canConfirm)
                    .font(.system(size: 15, weight: .semibold))
                }
            }
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(selectedDate: $selectedDate, isPresented: $showDatePicker)
        }
    }
}

// MARK: - Date picker sheet

private struct DatePickerSheet: View {
    @Binding var selectedDate: Date?
    @Binding var isPresented: Bool
    @State private var tempDate = Date()

    var body: some View {
        NavigationStack {
            DatePicker("Fecha de reserva", selection: $tempDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
                .navigationTitle("Seleccionar fecha")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancelar") { isPresented = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("OK") {
                            selectedDate = tempDate
                            isPresented  = false
                        }
                        .font(.system(size: 15, weight: .semibold))
                    }
                }
        }
    }
}
