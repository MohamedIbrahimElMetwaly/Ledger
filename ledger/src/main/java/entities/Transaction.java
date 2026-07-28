package entities;

import entities.enums.TransactionStatus;
import jakarta.persistence.*;

import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "transactions")
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private LocalDate date;

    private String note;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TransactionStatus status = TransactionStatus.ACTIVE;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reversal_id")
    private Transaction reversal;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "corrects_id")
    private Transaction corrects;

    @OneToMany(mappedBy = "transaction", cascade = CascadeType.ALL,
            orphanRemoval = true)
    private List<TransactionEntry> entries = new ArrayList<>();

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    // Tells Hibernate to run this function just before inserting to DB
    @PrePersist
    protected void onCreate() {
        this.createdAt = Instant.now();
    }

    public void addEntry(TransactionEntry entry) {
        entries.add(entry);
        entry.setTransaction(this);
    }

    // Getters and setters

    public Long getId() { return id; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public TransactionStatus getStatus() { return status; }
    public void setStatus(TransactionStatus status) { this.status = status; }

    public Transaction getReversal() { return reversal; }
    public void setReversal(Transaction reversal) { this.reversal = reversal; }

    public Transaction getCorrects() { return corrects; }
    public void setCorrects(Transaction corrects) { this.corrects = corrects; }

    public List<TransactionEntry> getEntries() { return entries; }

    public Instant getCreatedAt() { return createdAt; }
}
