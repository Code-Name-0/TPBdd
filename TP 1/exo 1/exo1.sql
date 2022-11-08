create database tp1exo1;
use tp1exo1;

create table Proprietaire (
	NomPro varchar(20) not null unique,
    Adresse varchar(50),
    Num_tel varchar(20),
    Categorie varchar(20),
    primary key(NomPro)
);

create table Type_ (
	NomType varchar(20) not null unique,
    NomCons varchar(20),
    Puissance varchar(20),
    Nb_places int,
    check (Nb_places > 8),
    primary key(NomType)
);

create table Mecanicien (
	IDMec int auto_increment not null,
    NomType varchar(20) not null,
    primary key(IDMec)
);


create table Pilote (
	IDPil int auto_increment not null,
    Num_brevet int,
    Nom varchar(20),
    Adresse varchar(20),
    Num_tel varchar(20),
    primary key(IDPil)
); 


create table Avion (
	Immatriculation varchar(20) not null,
    DateAchat DATE not null,
    NomType varchar(20) not null,
    NomPro varchar(20) not null,
    foreign key(NomType) references Type_(NomType),
    foreign key(NomPro) references Proprietaire(NomPro),
    primary key(Immatriculation)
);

create table Habilitation(
	IDMec int,
    NomType varchar(20) not null,
	foreign key(IDMec) references  Mecanicien(IDMec),
    foreign key(NomType) references Type_(NomType),
    primary key(IDMec, NomType)
);

create table Piloter(
	IDPil int not null,
    NomType varchar(20) not null,
    Nb_Vols int not null,
    check(Nb_Vols <= 20),
    foreign key(IDPil) references Pilote(IDPil),
    foreign key(NomType) references Type_(NomType),
    primary key(IDPil, NomType)
);


create table Intervention(
	Num int not null auto_increment,
    Immatriculation varchar(20) not null,
    IDMec_R int not null,
    IDMec_V int not null,
    Objet varchar(7),
    Date_int datetime not null,
    Duree int,
    foreign key(Immatriculation) references Avion(Immatriculation),
    foreign key(IDMec_R) references Mecanicien(IDMec),
    foreign key(IDMec_V) references Mecanicien(IDMec),
    check( Objet = "faire" or Objet = "reparer"),
    primary key(Num)
);

delimiter $$;
create trigger check_date_achat 
before INSERT
ON Intervention
FOR EACH ROW
begin
	IF NEW.Date_int <= ( select DateAchat from Avion Where Immatriculation=NEW.Immatriculation  ) THEN
		 RAISE EXCEPTION 'Invalid intervention date';
    end if;
END$$
delimiter ;