
-- 1. Album -> Artist
ALTER TABLE Album
ADD CONSTRAINT FK_Album_Artist
FOREIGN KEY (ArtistId) REFERENCES Artist(ArtistId);

-- 2. Employee (ReportsTo) -> Employee (self-reference)
ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_ReportsTo
FOREIGN KEY (ReportsTo) REFERENCES Employee(EmployeeId);

-- 3. Customer -> Employee (SupportRepId)
ALTER TABLE Customer
ADD CONSTRAINT FK_Customer_Employee
FOREIGN KEY (SupportRepId) REFERENCES Employee(EmployeeId);

-- 4. Invoice -> Customer
ALTER TABLE Invoice
ADD CONSTRAINT FK_Invoice_Customer
FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId);

-- 5. InvoiceLine -> Invoice
ALTER TABLE InvoiceLine
ADD CONSTRAINT FK_InvoiceLine_Invoice
FOREIGN KEY (InvoiceId) REFERENCES Invoice(InvoiceId);

-- 6. InvoiceLine -> Track
ALTER TABLE InvoiceLine
ADD CONSTRAINT FK_InvoiceLine_Track
FOREIGN KEY (TrackId) REFERENCES Track(TrackId);

-- 7. Track -> Album
ALTER TABLE Track
ADD CONSTRAINT FK_Track_Album
FOREIGN KEY (AlbumId) REFERENCES Album(AlbumId);

-- 8. Track -> MediaType
ALTER TABLE Track
ADD CONSTRAINT FK_Track_MediaType
FOREIGN KEY (MediaTypeId) REFERENCES MediaType(MediaTypeId);

-- 9. Track -> Genre
ALTER TABLE Track
ADD CONSTRAINT FK_Track_Genre
FOREIGN KEY (GenreId) REFERENCES Genre(GenreId);

-- 10. PlaylistTrack -> Playlist
ALTER TABLE PlaylistTrack
ADD CONSTRAINT FK_PlaylistTrack_Playlist
FOREIGN KEY (PlaylistId) REFERENCES Playlist(PlaylistId);

-- 11. PlaylistTrack -> Track
ALTER TABLE PlaylistTrack
ADD CONSTRAINT FK_PlaylistTrack_Track
FOREIGN KEY (TrackId) REFERENCES Track(TrackId);



