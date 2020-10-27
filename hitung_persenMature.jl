data_landings1 = CSV.read("Perikanan/data_hasil_olah.csv", header=true, delim=',', ignorerepeated=true, dateformat="m/dd/yyyy")


data_landings1 = dropmissing(data_landings1)
using Statistics
# buat tahun menjadi string
data_landings1[:Year] = repr.(data_landings1[:Year])
data_landings1[:Weight_kg] = float.(data_landings1[:Weight_gram] ./ 1000)
data_landings1

m95 = 15.9
# jumlah data yg diatas m95
persen = filter(row -> row[:Length_cm] > m95, data_landings1)
total = combine(groupby(data_landings1, [:Year]), nrow)
# jumlah semua data per-tahun
persen_mature = combine(groupby(persen, [:Year]), nrow)
# hitung jumlah persentase
hasil = persen_mature[:nrow] ./ total[:nrow]
persen_mature[:m95] = hasil
persen_mature