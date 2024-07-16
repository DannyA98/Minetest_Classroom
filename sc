// billWizard/renderExpense.jsx
import React from 'react';

// MUI components
import {
    Card,
    CardContent,
    FormControl,
    IconButton,
    InputLabel,
    Grid,
    MenuItem,
    Select,
    TextField
} from '@mui/material';

// Material Icons
import DeleteIcon from '@mui/icons-material/Delete';

const renderExpense = (expense, index, expenses, setExpenses, selectedCreditTypes, setSelectedCreditTypes, setIsSnackbarOpen) => {

    const creditTypes = ["Credit Type 1", "Credit Type 2", "Credit Type 3"];
    const serviceCreditMap = {
        "90% of Paper Treatment Plan Requests processed within seven Days": "4.3.2.1",
        "90% of Digital Services Treatment Plan Requests adjudicated within seven Days": "4.3.2.2",
        "95% of Treatment Plan Requests from EDI processed within seven Days": "4.3.2.3",
        "95% of Treatment Plan Requests from EDI adjudicated within seven Days": "4.3.2.4",
        "90% of Paper Claim processed within seven Days of receipt": "4.3.3.1",
        "90% of Out-of-Canada Claims processed within seven Days once all documentation is obtained": "4.3.3.5",
        "99% Financial Accuracy on all Paper Claims processed": "4.3.3.6",
        "98% Non-Financial Accuracy on all Paper Claims processed": "4.3.3.7",
        "95% EDI Claim Lines processed within two Days": "4.3.4.8",
        "99% Financial Accuracy on all Provider Claims processed": "4.3.4.9",
        "98% Non-Financial Accuracy on all Provider Claims processed": "4.3.4.10",
        "95% of Member Digital Claims processed within five Days": "4.3.5.11",
        "99% Financial Accuracy on Member Digital Claims processed": "4.3.5.12",
        "98% Non-Financial Accuracy on Member Digital Claims processed": "4.3.5.13",
        "70% English Calls Answered < 20 seconds": "4.10.14",
        "70% French Calls Answered < 20 seconds": "4.10.15",
        "85% First Call Resolution": "4.10.16",
        "99% Contact Centre Availability": "4.10.17",
        "99.5% Contact Centre Availability": "4.10.18",
        "95% Response rate of English inquiries within 2 Days": "4.10.19",
        "95% Response rate of French inquiries within 2 Days": "4.10.20",
        "70% English Real-time chat Answered < 20 seconds": "4.10.21",
        "70% French Real-time chat Answered < 20 seconds": "4.10.22",
        "100% Accuracy of all Standard Reports provided within a Quarter.": "4.9.22",
        "Prior Day Claim Verification Audits based on defined SVS criteria": "4.7.23",
        "Member confirmation Audits based on defined SVS criteria": "4.7.24",
        "Provider Desk Claim Verification Audits based on defined SVS criteria": "4.7.25",
        "Digital Claims Audits based on defined SVS criteria": "4.7.26",
        "Provider Confirmation Audits based on defined SVS criteria": "4.7.27",
        "Dependant Eligibility Verification Audits based on defined SVS criteria": "4.7.28"
    };

    const today = new Date().toISOString().split('T')[0];

    const handleExpenseChange = (index, field, value) => {
        let isDuplicate = false;

        // Check for duplicates only when updating the 'type'
        if (field === 'type') {
            isDuplicate = expenses.some((expense, idx) =>
                idx !== index && expense.type === value
            );

            if (isDuplicate) {
                setIsSnackbarOpen(true); // Show the Snackbar if it's a duplicate

            } else {
                // If not a duplicate, update the type and auto-advance the step if applicable
                expenses[index].type = value;
                expenses[index].step = Math.max(expenses[index].step, 1); // Advance to at least step 1
            }

        } else if (field === 'startDate') {
            const date = new Date(value);
            const firstDayOfMonth = new Date(date.getFullYear(), date.getMonth(), 1).toISOString().split('T')[0];

            expenses[index].startDate = firstDayOfMonth;
            expenses[index].step = Math.max(expenses[index].step, 2); // Advance to at least step 2

        } else if (field === 'endDate') {
            const date = new Date(value);
            const lastDayOfMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0).toISOString().split('T')[0];
            expenses[index].endDate = lastDayOfMonth;
            expenses[index].step = Math.max(expenses[index].step, 3); // Advance to at least step 3

        } else {
            // Handle other fields without auto-advancing steps
            expenses[index][field] = value;
        }

        // Trigger state update to re-render, avoiding direct mutation
        if (!isDuplicate || field !== 'type') {
            setExpenses([...expenses]);
        }
    };

    const handleRemoveExpense = (index) => {
        const typeToRemove = expenses[index].type;
        const newSelectedTypes = selectedCreditTypes.filter(type => type != typeToRemove);
        setSelectedCreditTypes(newSelectedTypes);
        const updatedExpenses = expenses.filter((_, idx) => idx !== index);
        setExpenses(updatedExpenses);
    };

    return (
        <Grid container spacing={3}>
            <Grid item xs={12}>
                <Card>
                    <div style={{display: "flex", justifyContent: "flex-end"} }>
                        <IconButton onClick={() => handleRemoveExpense(index)} style={{ top: '5px', right: '15px', zIndex: 1 }}
                            aria-label="delete">
                            <DeleteIcon />
                        </IconButton>
                    </div>

                    <CardContent>
                        <div>
                            {/* Always show the type selection */}

                            {expense.step >= 0 && (
                                <FormControl fullWidth variant="outlined" style={{ marginBottom: 16 }}>
                                    <InputLabel id="type-select-label">Type of Service Credit</InputLabel>
                                    <Select
                                        labelId="type-select-label"
                                        id="type-select"
                                        value={expense.type || ''}
                                        onChange={(e) => handleExpenseChange(index, 'type', e.target.value)}
                                        label="Type of Service Credit">
                                        {creditTypes.map((type) => (
                                            <MenuItem key={type} value={type}>{type}</MenuItem>
                                        ))}
                                    </Select>
                                </FormControl>
                            )}

                            {/* Show start date if at this step or past it */}

                            {expense.step >= 1 && (
                                <TextField label="Start Date" type="date" value={expense.startDate}
                                    onChange={(e) => handleExpenseChange(index, 'startDate', e.target.value)}
                                    fullWidth style={{ marginBottom: 16 }}
                                    InputLabelProps={{ shrink: true }}
                                    InputProps={{ inputProps: { max: new Date().toISOString().split('T')[0] } }}
                                />
                            )}

                            {/* Show end date if at this step or past it */}

                            {expense.step >= 2 && (
                                <TextField  label="End Date" type="date" value={expense.endDate}
                                    onChange={(e) => handleExpenseChange(index, 'endDate', e.target.value)} 
                                    fullWidth  style={{ marginBottom: 16 }}
                                    InputLabelProps={{ shrink: true }}
                                    InputProps={{ inputProps: { max: new Date().toISOString().split('T')[0] } }}
                                />
                            )}

                            {/* Show rate input if at this step */}

                            {expense.step >= 3 && (
                                <div>
                                    <TextField label="Credit Amount" type="number" value={expense.rate}
                                        onChange={(e) => handleExpenseChange(index, 'rate', e.target.value)}
                                        fullwidth="true" style={{ marginBottom: 16 }} />
                                </div>
                            )}
                        </div>
                    </CardContent>
                </ Card>
            </Grid>
        </Grid>
    );
};
export default renderExpense
