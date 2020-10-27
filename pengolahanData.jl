using CSV, Plots, DataFrames
import GR
# membaca file CSV 
# periksa file CSV yang digunakan seperti tanda pemisal (delim), menggunakan judul kolom (header), dan kolom dgn format tanggal
data_landings = CSV.read("Perikanan/sample_landings_data_raw.csv", header=true, delim=',', ignorerepeated=true, dateformat="m/dd/yyyy")
colnames = ["Year","Date","Trip_ID","Effort_Hours","Gear","Species","Length_cm","Weight_gram"]
# mengganti judul dari setiap kolom
names!(data_landings, Symbol.(colnames))
# using Pkg
Pkg.add("Missings")
using Missings
# Drop Missing Values
# Jika ingin mengganti nilai bisa menggunakan perintah
#  coalesce(data_landings, 0)  #misal menggantinnya dengan nilai 0
dropmissing(data_landings)
unique(data_landings[:Gear])

filter(row -> row[:Gear] == "Caesio cuning", data_landings)
data_baru = data_landings[data_landings[:Gear] .!= "Caesio cuning", :]
unique(data_baru[:Gear])
# berkaitan dengan string
# uppercase, uppercasefirst, lowercase, titlecase, lowercasefirst
data_baru[:Gear] = uppercasefirst.(data_baru[:Gear])
# cek nama type di spesies
unique(data_baru[:Species])
nrow(filter(row -> row[:Species] == "Caesio cuning", data_baru))
nrow(filter(row -> row[:Species] == "Caesoi cunning", data_baru))
# melihat statistik standar dari data
# jumlah, misiing count, mean, minimum, maximum, median dll
# ini dapat digunakan untuk mencari nilai yang tidak wajar
describe(data_baru[:Length_cm])

# panggil library Plots
using Plots
# memastikan dengan melihat dalam bentuk grafik
# jika ingin dalam bentuk line bisa menggunakan plot(data_baru[:Length_cm])
scatter(data_baru[:Length_cm])
# lakukan filter dimana data yang baik yaitu dibawah 1 meter
data_baru = filter(row -> row[:Length_cm] < 100, data_baru)
scatter(data_baru[:Length_cm])
# menyimpan hasil data yang telah di-cleaning kedalam file CSV
CSV.write("Perikanan/data_hasil_olah.csv", data_baru)


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
combine(groupby(data_landings1, [:Year, :Gear]), numcols .=> sum .=> numcols)

bar(data_tahun_alat[:Year], 
data_tahun_alat[:Weight_kg], 
title="Total Tangkapan (Kg) per-Tahun",
label="total (kg)",
xlabel="Tahun",
ylabel="Tangkapan (Kg) ")

savefig("hasil_1.png")

