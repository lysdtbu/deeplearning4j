/*
 *  ******************************************************************************
 *  * Copyright (c) 2021 Deeplearning4j Contributors
 *  *
 *  * This program and the accompanying materials are made available under the
 *  * terms of the Apache License, Version 2.0 which is available at
 *  * https://www.apache.org/licenses/LICENSE-2.0.
 *  *
 *  * Unless required by applicable law or agreed to in writing, software
 *  * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 *  * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 *  * License for the specific language governing permissions and limitations
 *  * under the License.
 *  *
 *  * SPDX-License-Identifier: Apache-2.0
 *  *****************************************************************************
 */

package org.nd4j.linalg.api.ops.impl.updaters;

import lombok.NonNull;
import org.nd4j.linalg.api.ndarray.INDArray;
import org.nd4j.linalg.api.ops.DynamicCustomOp;

/**
 *
 * @author raver119@gmail.com
 */
public class AdaDeltaUpdater extends DynamicCustomOp {

    public AdaDeltaUpdater() {
        //
    }

    public AdaDeltaUpdater(@NonNull INDArray gradients, @NonNull INDArray stateMsg, @NonNull INDArray stateMsdx, double rho, double epsilon) {
        this(gradients, stateMsg, stateMsdx, gradients, stateMsg, stateMsdx, rho, epsilon);
    }

    public AdaDeltaUpdater(@NonNull INDArray gradients, @NonNull INDArray stateMsg, @NonNull INDArray stateMsdx, @NonNull INDArray updates, @NonNull INDArray updatedStateMsg, @NonNull INDArray updatedStateMsdx, double rho, double epsilon) {
        addInputArgument(gradients, stateMsg, stateMsdx);
        addOutputArgument(updates, updatedStateMsg, updatedStateMsdx);
        addTArgument(rho, epsilon);
    }

    @Override
    public String opName() {
        return "ada_delta_updater";
    }
}