# This is the object that contains the LSA semantic space.
#
# This is where the magic takes place.
#
# Revision History:
# ~~~~~~~~~~~~~~~~~
# 08/10/2019 - CJL
###

import numpy as np  # For SVD Calculation
import math  # For sqrt function


class SemanticSpace:
    ##
    # Constructor
    #
    # Takes one parameter, I, which is the InvertedIndex that we want to build
    # a semantic space from.
    #
    # @param I - InvertedIndex object.
    #
    # Revision History:
    # ~~~~~~~~~~~~~~~~~
    # 08/10/2019 - Created (CJL).
    ###
    def __init__(self, I):
        # Store the Inverted Index
        self.I = I

        # Generate our term by document matrix "A"
        self.A = self.I.generate_term_by_doc_matrix()

        # Output from our SVD operation
        self.T = None
        self.S = None
        self.Dt = None

        # Perform the SVD operation on A
        self.T, self.S, self.Dt = np.linalg.svd(self.A, full_matrices=False)

        # Create a prefabricated inverse of the singular values as well
        # as the squares.
        # (shortcut for operations - can you see how they would help?)
        self.S_inv = [1.0 / x for x in self.S]
        self.S_sq = [x * x for x in self.S]

        # Set our dimensional reduction value default (value of "k")
        self.max_dimension = 2

    ##
    # Create a query vector from a string of text representing the
    # query.  This includes the "folding in" of the query such that
    # it is in the same dimensional space as our semantic space
    # created through our SVD calculation.
    #
    # Note, this essentially transforms our query into a "Document"
    # in our semantic space.  In theory, if we were expanding our
    # semantic space with more documents we would just "fold them
    # in" with an operation like this and append them to the Dt
    # matrix.  Obviously the more you fold in the more it waters
    # down the relationships encapsulated in the original SVD
    # calculation.
    #
    # @param q - String representing query.
    #
    # @return Vector representing the query in our semantic space.
    #
    # Revision History:
    # ~~~~~~~~~~~~~~~~~
    # 09/10/2019 - Created (CJL).
    ###
    def create_query_vector(self, q):
        ret_q = [0.0 for i in range(self.I.get_total_terms())]

        # This is where we ensure the query text is tokenized and processed
        # the same as the text was in the Inverted Index (we use the same
        # function call).  It's important any terms we introduce as a query
        # are in the same format as what can be found in the semantic space
        # (if they are there at all).
        q = self.I.process_text(q)

        # TODO:  Fill in the rest of this method.
        # You will need to:
        #    A) create a query vector (simple vector representing
        #       the TF of each of the terms present in the query (processed
        #       above).
        #    B) Complete the "fold_in_query" method

        # Now create a query vector
        for t in q:
            item = self.I.search_for_term(t)

            if item[0] is not None:
                ret_q[item[1]] += 1

        ##
        # If our semantic space was generated from an initial weighted A matrix
        # than we would need to weight our query vector the same way.  You'd
        # do that here.
        ##

        ret_q = self.fold_in_query(ret_q)

        return ret_q

    ##
    # This function takes a vector representation of a document or query
    # and folds it into our semantic space.
    #
    # The new query is calculated as qTS^{-1}
    #
    # @param q - Query in a vector format.
    #
    # @return Query folded into the semantic space.
    #
    # Revision History:
    # ~~~~~~~~~~~~~~~~~
    # 09/10/2019 - Created (CJL).
    ###
    def fold_in_query(self, q):
        # new query is qTS^{-1}
        no_terms = self.T.shape[0]
        rank = self.T.shape[1]

        # Create vector for folded in query
        fol_q = [0.0 for i in range(rank)]

        # TODO:  Complete this function.
        # The T matrix will have as many rows as corresponds to terms but
        # will have *rank* number of columns.  Perform the calculation
        # as outlined above.
        #
        # Can you optimise this further using the S_inv array in the constructor?

        # Multiply q by T
        qt_arr = np.atleast_2d(q)
        tmp = np.dot(qt_arr, self.T)

        # and scale by S^{-1}
        for i in range(rank):
            fol_q[i] = tmp[0][i] * self.S_inv[i]

        return fol_q

    ##
    # Calculates the cosine between a query vector and a document
    # in our semantic space.
    #
    # NOTE:  This assumes the query vector has already been "folded in"
    #        to the semantic space.
    #
    # @param q   - Query vector
    #        doc - Index into the Dt indicating the column (document)
    #              we wish to compare the query against.
    #
    # @return The cosine value between the query and specified document
    #         vector.
    #
    # Revision History:
    # ~~~~~~~~~~~~~~~~~
    # 09/10/2019 - Created (CJL).
    ###
    def cosine_with_doc(self, q, doc):
        # Can you optimise this further using the S_sq array generated
        # in the constructor?
        doc = self.Dt[:, doc][:self.max_dimension]
        q = np.array(q)[:self.max_dimension]

        # TODO:  Complete this method
        for i in range(self.max_dimension):
            q *= self.S[i]
            doc *= self.S[i]

        return np.dot(q, doc) / (np.linalg.norm(q) * np.linalg.norm(doc))

    ##
    # Calculates the cosine between two terms in our semantic space.
    #
    # @param t1 - Index (row) of the first term to compare
    # @param t2 - Index (row) of the 2nd term to compare.
    #
    # @return The cosine value term t1 and term t2 in our semantic space.
    #
    # Revision History:
    # ~~~~~~~~~~~~~~~~~
    # 09/10/2019 - Created (CJL).
    ###
    def cosine_with_term(self, t1, t2):
        t1_matx = self.T[t1][:self.max_dimension]
        t2_matx = self.T[t2][:self.max_dimension]

        #Scale 
        #np.matmul(t1_matx, self.S)
        #np.matmul(t2_matx, self.S)

        
        # Can you optimise this further using the S_sq array generated
        # in the constructor?

        # TODO:  Complete this method
        for i in range(self.max_dimension):
            t1_matx *= self.S[i]
            t2_matx *= self.S[i]

        # m_t1 and m_t2 are the magnitudes of the term vectors
        m_t1 = np.linalg.norm(t1_matx)
        m_t2 = np.linalg.norm(t2_matx)

        # This would be the dot product of t1*S [dot] t2*S
        calc = np.dot(t1_matx, t2_matx)

        cos = calc / (m_t1 * m_t2)

        return cos
