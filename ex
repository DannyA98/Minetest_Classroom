// billWizard/renderExpense.jsx
import React, { useState } from 'react';

import { addDays, startOfMonth, endOfMonth } from 'date-fns';

// MUI components
import {
    Card,
    CardContent,
    Typography,
    FormControl,
    IconButton,
    InputLabel,
    Grid,
    MenuItem,
    Select,
    TextField
} from '@mui/material';

import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';

// Material Icons
import DeleteIcon from '@mui/icons-material/Delete';




const renderExpense = (expense, index, expenses, setExpenses, selectedCreditTypes, setSelectedCreditTypes, setIsSnackbarOpen, isMenuOpen, setIsMenuOpen, toggleMenu) => {

    const handleSelect = (index, key) => {
        handleExpenseChange(index, 'type', key);
        setIsMenuOpen(false);
    };


    const creditTypes = ["Credit Type 1", "Credit Type 2", "Credit Type 3"];
    const serviceCreditMap = {
        "4.3.2.1 90% of Paper Treatment Plan Requests processed within seven Days": "4.3.2.1",
        "4.3.2.2 90% of Digital Services Treatment Plan Requests adjudicated within seven Days": "4.3.2.2",
        "4.3.2.3 95% of Treatment Plan Requests from EDI processed within seven Days": "4.3.2.3",
        "4.3.2.4 95% of Treatment Plan Requests from EDI adjudicated within seven Days": "4.3.2.4",
        "4.3.3.1 90% of Paper Claim processed within seven Days of receipt": "4.3.3.1",
        "4.3.3.5 90% of Out-of-Canada Claims processed within seven Days once all documentation is obtained": "4.3.3.5",
        "4.3.3.6 99% Financial Accuracy on all Paper Claims processed": "4.3.3.6",
        "4.3.3.7 98% Non-Financial Accuracy on all Paper Claims processed": "4.3.3.7",
        "4.3.4.8 95% EDI Claim Lines processed within two Days": "4.3.4.8",
        "4.3.4.9 99% Financial Accuracy on all Provider Claims processed": "4.3.4.9",
        "4.3.4.10 98% Non-Financial Accuracy on all Provider Claims processed": "4.3.4.10",
        "4.3.5.11 95% of Member Digital Claims processed within five Days": "4.3.5.11",
        "4.3.5.12 99% Financial Accuracy on Member Digital Claims processed": "4.3.5.12",
        "4.3.5.13 98% Non-Financial Accuracy on Member Digital Claims processed": "4.3.5.13",
        "4.7.23 Prior Day Claim Verification Audits based on defined SVS criteria": "4.7.23",
        "4.7.24 Member confirmation Audits based on defined SVS criteria": "4.7.24",
        "4.7.25 Provider Desk Claim Verification Audits based on defined SVS criteria": "4.7.25",
        "4.7.26 Digital Claims Audits based on defined SVS criteria": "4.7.26",
        "4.7.27 Provider Confirmation Audits based on defined SVS criteria": "4.7.27",
        "4.7.28 Dependant Eligibility Verification Audits based on defined SVS criteria": "4.7.28",
        "4.9.22 100% Accuracy of all Standard Reports provided within a Quarter.": "4.9.22",
        "4.10.14 70% English Calls Answered < 20 seconds": "4.10.14",
        "4.10.15 70% French Calls Answered < 20 seconds": "4.10.15",
        "4.10.16 85% First Call Resolution": "4.10.16",
        "4.10.17 99% Contact Centre Availability": "4.10.17",
        "4.10.18 99.5% Contact Centre Availability": "4.10.18",
        "4.10.19 95% Response rate of English inquiries within 2 Days": "4.10.19",
        "4.10.20 95% Response rate of French inquiries within 2 Days": "4.10.20",
        "4.10.21 70% English Real-time chat Answered < 20 seconds": "4.10.21",
        "4.10.22 70% French Real-time chat Answered < 20 seconds": "4.10.22"
      
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
            const nextDay = addDays(date, 2);
            const firstDayOfMonth = startOfMonth(nextDay).toISOString().split('T')[0];
            expenses[index].startDate = firstDayOfMonth;
            console.log(expenses[index].startDate)
            expenses[index].step = Math.max(expenses[index].step, 2); // Advance to at least step 2

        } else if (field === 'endDate') {
            const date = new Date(value);
            const lastDayOfMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0).toISOString().split('T')[0];
            expenses[index].endDate = lastDayOfMonth;
            expenses[index].step = Math.max(expenses[index].step, 3); // Advance to at least step 3

        } else if (field === 'rate') {
            expenses[index].rate = value;
            expenses[index].step = Math.max(expenses[index].step, 4); // Advance to at least step 3

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
                                <div>
                                    <Typography variant="h6">Type of Service Credit:</Typography>
                                    <Typography variant="body1" onClick={toggleMenu} style={{ cursor: 'pointer', marginBottom: '8px' }}>
                                        {expense.type || 'Select a Service Credit'}
                                    </Typography>
                                    {isMenuOpen && (
                                        <div style={{ maxHeight: '400px', overflowY: 'auto', border: '1px solid #ccc', borderRadius: '4px', padding: '8px' }}>
                                            {Object.keys(serviceCreditMap).map((key) => (
                                                <MenuItem
                                                    key={key}
                                                    value={key}
                                                    style={{
                                                        fontSize: '0.875rem',
                                                        cursor: 'pointer',
                                                        padding: '8px 16px',
                                                        backgroundColor: expense.type === key ? '#f0f0f0' : 'transparent'
                                                    }}
                                                    onClick={() => handleSelect(index, key)}
                                                >
                                                    {key}
                                                </MenuItem>
                                            ))}
                                        </div>
                                    )}
                                </div>
                            )}
                       

          
                            {/* Show start date if at this step or past it */}

                            {expense.step >= 1 && (
                                <div style ={{marginTop: '16px', marginRight: '16px'} }>
                                    <DatePicker stlye={{ marginLeft: '16px' }}
                                        selected={expense.startDate ? new Date(expense.startDate) : null}
                                    onChange={(date) => handleExpenseChange(index, 'startDate', date)}
                                     dateFormat="MMMM d, yyyy"
                                        showMonthYearPicker
                                        minDate={new Date(2024, 10, 1)} // November 1st, 2024
                                    customInput={
                                        <TextField
                                            label="Start Date"
                                            fullWidth
                                            style={{ marginBottom: '16px' }}
                                            InputLabelProps={{ shrink: true }}
                                        />
                                      
                                    }
                                />
                                </div>
                            )}

                            {/* Show end date if at this step or past it */}

                            {expense.step >= 2 && (
                                <DatePicker style={{marginLeft: '16px'} }
                                    selected={expense.endDate ? new Date(expense.endDate) : null}
                                    onChange={(date) => handleExpenseChange(index, 'endDate', date)}
                                    dateFormat="MMMM d, yyyy"
                                    showMonthYearPicker
                                    minDate={expense.startDate ? new Date(expense.startDate) : new Date(2024, 10, 1)} // Start date or November 1st, 2024
                                    customInput={
                                        <TextField
                                            label="End Date"
                                            fullWidth
                                            style={{ marginBottom: '16px' }}
                                            InputLabelProps={{ shrink: true }}
                                        />
                                    }
                                />
                            )}

                            {/* Show rate input if at this step */}

                            {expense.step >= 3 && (
                                <div>
                                    <TextField label="Credit Amount" type="number" value={expense.rate}
                                        onChange={(e) => {
                                            const value = e.target.value;
                                            if (/^\d*\.?\d{0,2}$/.test(value)) {
                                                handleExpenseChange(index, 'rate', value);
                                            }
                                        }}
                                        fullwidth="true" style={{ marginBottom: 16 }} 
                                        inputProps={{ step: "0.01" }}
                                    sx={{
                                        "& input::-webkit-outer-spin-button, & input::-webkit-inner-spin-button": {
                                            display: "none",
                                        }
                                    }}                                    />
                                </div>
                            )}

                            {/* Show amount input if at this step */}

                            {expense.step >= 4 && (
                                <div>
                                    <TextField label="Credit Rate %" type="number" value={expense.amount}
                                        onChange={(e) => {
                                            const value = e.target.value;
                                            if (/^\d*\.?\d{0,2}$/.test(value)) {
                                                handleExpenseChange(index, 'amount', value);
                                            }
                                        }}
                                        fullwidth="true" style={{ marginBottom: 16 }}
                                        inputProps={{ step: "0.01" }}
                                    sx={{
                                        "& input::-webkit-outer-spin-button, & input::-webkit-inner-spin-button": {
                                            display: "none",
                                        }
                                    }}                                    />
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
