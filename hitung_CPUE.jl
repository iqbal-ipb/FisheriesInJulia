data_landings1 = CSV.read("Perikanan/data_hasil_olah.csv", header=true, delim=',', ignorerepeated=true, dateformat="m/dd/yyyy")


data_landings1 = dropmissing(data_landings1)
using Statistics
# buat tahun menjadi string
data_landings1[:Year] = repr.(data_landings1[:Year])
data_landings1[:Weight_kg] = float.(data_landings1[:Weight_gram] ./ 1000)


# mencari kolom yg bernilai angka
numcols = names(data_landings1, findall(x -> eltype(x) <: Number, eachcol(data_landings1)))
# melakukan grouping dan agregasi nilai misal sum 
# grouping terhadapa kolom Year dan Gear, ini bisa disesuaikan dengan kebutuhan
# nilai aggregat yg digitung jg bisa disesuaikan dengan menentukan colom apa saja di numcols
data_tahun_alat = combine(groupby(data_landings1, [:Year]), numcols .=> sum .=> numcols)


bar(data_tahun_alat[:Year], 
data_tahun_alat[:Weight_kg], 
title="Total Tangkapan (Kg) per-Tahun",
label="total (kg)",
xlabel="Tahun",
ylabel="Tangkapan (Kg) ")

savefig("hasil_1.png")

data_year_trip = combine(groupby(data_landings1, [:Year, :Trip_ID]), 
                [:Effort_Hours .=> mean .=> "Rata_Effort", 
                :Weight_kg .=> sum .=> "Jumlah_Total"])

data_year_trip[:CPUE] = data_year_trip[:Jumlah_Total] ./ data_year_trip[:Rata_Effort]
hitung_cpue = combine(groupby(data_year_trip, [:Year]), 
            ["Rata_Effort", "Jumlah_Total",
            "CPUE"] .=> median .=> ["Rata_Effort", 
            "Jumlah_Total", "CPUE"])